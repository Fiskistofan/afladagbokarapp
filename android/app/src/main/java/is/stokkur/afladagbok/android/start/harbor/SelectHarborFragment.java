/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2022 Stokkur Software ehf.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package is.stokkur.afladagbok.android.start.harbor;

import androidx.lifecycle.ViewModelProviders;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.collection.ArrayMap;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Editable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.google.gson.reflect.TypeToken;

import java.text.Collator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import is.stokkur.afladagbok.android.AfladagbokApplication;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.models.Port;
import is.stokkur.afladagbok.android.models.StartTourBody;
import is.stokkur.afladagbok.android.start.StartTourActivity;
import is.stokkur.afladagbok.android.start.StartTourViewModel;
import is.stokkur.afladagbok.android.utils.GsonInstance;
import is.stokkur.afladagbok.android.utils.Persistence;
import is.stokkur.afladagbok.android.utils.Utils;
import is.stokkur.afladagbok.android.widget.TextWatcherAdapter;

/**
 * Created by annalaufey on 11/29/17.
 */

public class SelectHarborFragment
        extends BaseFragment
        implements HarborSelectedListener {

    @BindView(R.id.harbor_txt)
    EditText harborText;

    @BindView(R.id.start_tour_progress_bar)
    ProgressBar progressBar;

    private TextView mSelectedPort;

    StartTourViewModel viewModel;
    StartTourBody startTourBody;

    private HarborAdapter mAdapter;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.select_harbor_fragment, container, false);
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        ((StartTourActivity) getActivity()).changeHeaderTitle(getString(R.string.final_step));
        viewModel = ViewModelProviders.of(getActivity()).get(StartTourViewModel.class);
        viewModel.mView = this;

        loadRecentsData();
        ArrayList<Port> ports = sortPorts(viewModel.getPorts());

        mSelectedPort = view.findViewById(R.id.selected_harbor);

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity());
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        RecyclerView recyclerView = view.findViewById(R.id.harbor_recycler_view);
        recyclerView.setLayoutManager(linearLayoutManager);

        mAdapter = new HarborAdapter(ports, getActivity(), this);
        recyclerView.setAdapter(mAdapter);

        harborText.addTextChangedListener(new TextWatcherAdapter() {
            @Override
            public void afterTextChanged(Editable text) {
                super.afterTextChanged(text);
                mAdapter.getFilter().filter(text);
            }
        });

        startTourBody = new StartTourBody();
        Port port = ports.get(0);
        selectHarbor(port.getId(), port.getPortName());
    }

    @Override
    public void onPause() {
        super.onPause();
        saveRecentsData();
    }

    @OnClick(R.id.start_tour_button)
    public void onStartTourClicked() {
        String portId = startTourBody.getPortId();
        if (portId == null) {
            return;
        }

        if (Utils.isNetworkAvailable()) {
            showProgressBar();
            updateRecentsData(portId);
            viewModel.getTourResponse().observe(getActivity(), startTourResponse -> {
                hideProgressBar();
                AfladagbokApplication.getInstance().startSyncJob();
                if (getActivity() != null && !getActivity().isFinishing()) {
                    getActivity().finish();
                }
            });
            viewModel.getError().observe(getActivity(), errorWrapper -> {
                hideProgressBar();
                if (errorWrapper != null && errorWrapper.getThrowable() != null) {
                    displayError(errorWrapper.getThrowable().getMessage(), true);
                } else {
                    displayError(getString(R.string.general_error), true);
                }
            });
            viewModel.startTour(startTourBody);
        } else {
            displayError(getString(R.string.no_internet_error), true);
        }
    }

    @Override
    public void selectHarbor(String portId, String portName) {
        mSelectedPort.setText(getString(R.string.selected_port, portName));
        mAdapter.getFilter().filter("");
        startTourBody.setPortId(portId);
        startTourBody.setEquipment(viewModel.getStartTourEquipment());
        startTourBody.setShipId(Persistence.getStringValue(Persistence.KEY_CURRENT_BOAT_ID));
    }

    @Override
    public void showProgressBar() {
        super.showProgressBar();
        progressBar.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideProgressBar() {
        super.hideProgressBar();
        progressBar.setVisibility(View.INVISIBLE);
    }

    // --- Recents --- //

    private ArrayMap<String, Long> mRecentsMap = new ArrayMap<>();
    private Collator mPortCollator = Collator.getInstance();
    private Comparator<Port> mPortComparator = (o1, o2) -> {
        long time1 = 0;
        String id1 = o1.getId();
        if (mRecentsMap.containsKey(id1)) {
            time1 = mRecentsMap.get(id1);
        }
        long time2 = 0;
        String id2 = o2.getId();
        if (mRecentsMap.containsKey(id2)) {
            time2 = mRecentsMap.get(id2);
        }
        if (time1 == time2) {
            return mPortCollator.compare(o1.getPortName(), o2.getPortName());
        } else if (time1 == 0) {
            return 1;
        } else if (time2 == 0) {
            return -1;
        } else {
            return (int) (time2 - time1);
        }
    };

    private void loadRecentsData() {
        mPortCollator.setStrength(Collator.NO_DECOMPOSITION);
        String recentsJson = Persistence.getStringValue(Persistence.KEY_RECENT_PORTS);
        TypeToken<ArrayMap<String, Long>> typeToken = new TypeToken<ArrayMap<String, Long>>() {
        };
        ArrayMap<String, Long> fromJson = GsonInstance.sInstance.
                fromJson(recentsJson, typeToken.getType());
        if (fromJson != null) {
            mRecentsMap.putAll((Map<String, Long>) fromJson);
        }
    }

    private ArrayList<Port> sortPorts(ArrayList<Port> ports) {
        Collections.sort(ports, mPortComparator);
        return ports;
    }

    private void saveRecentsData() {
        String recentsJson = GsonInstance.sInstance.toJson(mRecentsMap);
        Persistence.saveStringValue(Persistence.KEY_RECENT_PORTS, recentsJson);
    }

    private void updateRecentsData(String id) {
        long count = 0;
        if (mRecentsMap.containsKey(id)) {
            count = mRecentsMap.get(id);
        }
        mRecentsMap.put(id, ++count);
    }

    // --- Recents --- //

}
