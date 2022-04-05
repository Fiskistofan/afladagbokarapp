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

package is.stokkur.afladagbok.android.finish;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ProgressBar;

import androidx.annotation.Nullable;
import androidx.lifecycle.ViewModelProviders;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.ActionListener;
import is.stokkur.afladagbok.android.AfladagbokApplication;
import is.stokkur.afladagbok.android.MainActivity;
import is.stokkur.afladagbok.android.ProgressListener;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseActivity;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.adapters.ActiveTossesAdapter;
import is.stokkur.afladagbok.android.activeTossInfo.ActiveTossInfoActivity;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.dialogs.ErrorDisplayable;
import is.stokkur.afladagbok.android.dialogs.PromptDialogListener;
import is.stokkur.afladagbok.android.dialogs.RegisterCatchDialog;
import is.stokkur.afladagbok.android.dialogs.StopTourDialog;
import is.stokkur.afladagbok.android.dialogs.StopTourListener;
import is.stokkur.afladagbok.android.models.StatisticsDetailResponse;
import is.stokkur.afladagbok.android.models.TourCatchDetailDto;
import is.stokkur.afladagbok.android.statistics.StatisticHelper;
import is.stokkur.afladagbok.android.utils.Persistence;
import is.stokkur.afladagbok.android.utils.Utils;

public class FinishFragment extends BaseFragment implements
        ErrorDisplayable, ActionListener, StopTourListener, ActiveTossesAdapter.ActiveTossListener,
        PromptDialogListener {
    FinishViewModel viewModel;
    private List<StoredToss> storedTossArrayList;

    private ProgressBar mEndTourProgressBar;

    @BindView(R.id.linearLayout)
    LinearLayout infoLayout;
    @BindView(R.id.tosses_list)
    RecyclerView tossesRecyclerView;

    ActiveTossesAdapter adapter;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater,
                             @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.finish_fragment, container, false);
        ButterKnife.bind(this, view);
        viewModel = ViewModelProviders.of(this).get(FinishViewModel.class);
        viewModel.mView = this;
        viewModel.getError().observe(this, errorWrapper -> {
            if (errorWrapper != null && errorWrapper.getThrowable() != null) {
                showError(errorWrapper.getThrowable().getMessage(), true);
            } else {
                showError(getResources().getString(R.string.general_error), true);
            }
        });

        storedTossArrayList = new ArrayList<>();
        initRecyclerView(storedTossArrayList);
        return view;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        mEndTourProgressBar = view.findViewById(R.id.end_tour_progress);
        mEndTourProgressBar.setVisibility(View.VISIBLE);
    }

    @SuppressLint("CheckResult")
    @Override
    public void onResume() {
        super.onResume();
        // Change UI according to tour active or not.
        setUI();
        ((MainActivity) getActivity()).setActionListener(this);
        getAllToss();
    }

    @Override
    public void onPause() {
        super.onPause();
    }

    public void showError(String error, boolean isError) {
        getActivity().runOnUiThread(() -> displayError(error, isError));
    }

    @Override
    public void displayError(String message, boolean isError) {
        super.displayError(message, isError);
        mEndTourProgressBar.setVisibility(View.INVISIBLE);
    }

    private void initRecyclerView(List<StoredToss> registeredCatch) {
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity());
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        DividerItemDecoration dividerItemDecoration = new DividerItemDecoration(tossesRecyclerView.getContext(),
                linearLayoutManager.getOrientation());
        dividerItemDecoration.setDrawable(getContext().getDrawable(R.drawable.active_toss_divider_shape));
        tossesRecyclerView.addItemDecoration(dividerItemDecoration);
        tossesRecyclerView.setLayoutManager(linearLayoutManager);
        adapter = new ActiveTossesAdapter(registeredCatch, this, getActivity(), ActiveTossesAdapter.AdapterType.FOR_FINISH);
        tossesRecyclerView.setAdapter(adapter);
    }

    public void setUI() {
        if (Persistence.getBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP)) {
            if(storedTossArrayList.isEmpty()) {
                infoLayout.setVisibility(View.VISIBLE);
                tossesRecyclerView.setVisibility(View.GONE);
            } else {
                infoLayout.setVisibility(View.GONE);
                tossesRecyclerView.setVisibility(View.VISIBLE);
            }
        } else {
            infoLayout.setVisibility(View.VISIBLE);
            tossesRecyclerView.setVisibility(View.GONE);
        }
        hideProgressBar();
    }

    /**
     * Shows a dialog that asks if you are sure if you want to stop the tour
     */
    private void promptStopTourDialog() {
        new StopTourDialog(this).show();
    }

    public void stopTourConfirmed() {
        mEndTourProgressBar.setVisibility(View.VISIBLE);
        viewModel.confirmTour(Utils.getCurrentTourId());
    }

    public void endTour() {
        ((MainActivity) getActivity()).setActionButton();
        ((MainActivity) getActivity()).setEquipmentSelection();
        AfladagbokApplication.getInstance().cancelSyncJob();
        mEndTourProgressBar.setVisibility(View.INVISIBLE);
    }

    @Override
    public void onActionClicked(View view) {
        if (Persistence.getBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP)) {
            showProgressBar();
            viewModel.getStatisticDetail(Utils.getCurrentTourId());
        }
    }

    @Override
    public void onClick(StoredToss st, int positionId) {
        Intent storeTossInfoIntent = new Intent(getContext(), ActiveTossInfoActivity.class);
        storeTossInfoIntent.putExtra(ActiveTossInfoActivity.ACTIVE_TOSS_EXTRA_NAME, st);
        storeTossInfoIntent.putExtra(ActiveTossInfoActivity.ACTIVE_TOSS_POS_ID_EXTRA_NAME, positionId);
        startActivityForResult(storeTossInfoIntent,ActiveTossInfoActivity.ACTIVE_TOSS_PULL_REQ_CODE);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == ActiveTossInfoActivity.ACTIVE_TOSS_PULL_REQ_CODE && resultCode == Activity.RESULT_OK) {
            StoredToss storedToss = data.getParcelableExtra(ActiveTossInfoActivity.ACTIVE_TOSS_EXTRA_NAME);
            String amount = data.getStringExtra(ActiveTossInfoActivity.TOSS_PULLED_AMOUNT_EXTRA_NAME);
            ((BaseActivity) getActivity()).setPromptDialogListener(this);
            viewModel.registerNewPullInData(storedToss.getId(), amount, storedToss.getEquipmentTypeId());
        }
    }

    @Override
    public void promptDialog() {
        promptRegisterCatchDialog();
    }

    public void promptRegisterCatchDialog() {
        if (this.getActivity() != null) {
            new RegisterCatchDialog(this).show();
        }
    }

    /**
     * Listens to changes in the database to see if there are any new stored tosses
     */
    public void getAllToss() {
        if (Persistence.getBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP) &&
                Persistence.getStringValue(Persistence.KEY_CURRENT_ACTIVE_TRIP) != null) {
            viewModel.getStoredToss().observe(this, storedTosses -> {
                if (storedTosses != null) {
                    ArrayList<StoredToss> filteredList = new ArrayList<StoredToss>();
                    for (StoredToss st : storedTosses) {
                        if(st.getCount() - st.getPulledCount() > 0){
                            filteredList.add(st);
                        }
                    }

                    storedTossArrayList = filteredList;
                    setUI();
                    adapter.storedTosses = storedTossArrayList;
                    adapter.notifyDataSetChanged();
                }
            });
        }
    }

    @Override
    public void showProgressBar() {
        super.showProgressBar();
        mEndTourProgressBar.setVisibility(View.VISIBLE);
        Activity act = getActivity();
        if(act instanceof ProgressListener){
            ((ProgressListener) act).onProgressStarted();
        }
    }

    @Override
    public void hideProgressBar() {
        super.hideProgressBar();
        mEndTourProgressBar.setVisibility(View.INVISIBLE);
        Activity act = getActivity();
        if(act instanceof ProgressListener){
            ((ProgressListener) act).onProgressFinished();
        }
    }

    public void handleStatisticDetailResponse(StatisticsDetailResponse response) {
        hideProgressBar();
        new FinishTourDialog(this, response).show();
    }
}
