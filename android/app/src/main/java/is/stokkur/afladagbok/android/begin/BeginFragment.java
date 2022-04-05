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

package is.stokkur.afladagbok.android.begin;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.location.Location;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.lifecycle.ViewModelProviders;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.ActionListener;
import is.stokkur.afladagbok.android.MainActivity;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.activeTossInfo.ActiveTossInfoActivity;
import is.stokkur.afladagbok.android.adapters.ActiveTossesAdapter;
import is.stokkur.afladagbok.android.base.BaseActivity;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.dialogs.ErrorDisplayable;
import is.stokkur.afladagbok.android.dialogs.PromptDialogListener;
import is.stokkur.afladagbok.android.dialogs.PullHandDialog;
import is.stokkur.afladagbok.android.dialogs.PullHandRegistrable;
import is.stokkur.afladagbok.android.dialogs.PullNetOrLineDialog;
import is.stokkur.afladagbok.android.dialogs.PullNetOrLineRegistrable;
import is.stokkur.afladagbok.android.dialogs.RegisterCatchDialog;
import is.stokkur.afladagbok.android.dialogs.SelectTossDialog;
import is.stokkur.afladagbok.android.dialogs.TossInfoDialog;
import is.stokkur.afladagbok.android.dialogs.TossInfoHandler;
import is.stokkur.afladagbok.android.dialogs.TossOutDialog;
import is.stokkur.afladagbok.android.dialogs.TossOutListener;
import is.stokkur.afladagbok.android.models.FishingEquipments;
import is.stokkur.afladagbok.android.models.RegisterTossBody;
import is.stokkur.afladagbok.android.models.StartTourResponse;
import is.stokkur.afladagbok.android.start.StartTourActivity;
import is.stokkur.afladagbok.android.utils.GsonInstance;
import is.stokkur.afladagbok.android.utils.Persistence;
import is.stokkur.afladagbok.android.utils.Utils;

import static is.stokkur.afladagbok.android.utils.Utils.getTossType;
import static is.stokkur.afladagbok.android.utils.Utils.getTourType;

public class BeginFragment extends BaseFragment
        implements ActionListener, TossOutListener, TossInfoHandler, PullHandRegistrable,
        PullNetOrLineRegistrable, PromptDialogListener, ErrorDisplayable, ActiveTossesAdapter.ActiveTossListener {
    BeginViewModel viewModel;
    private List<StoredToss> storedTossArrayList;

    private ProgressBar mEndTourProgressBar;

    @BindView(R.id.tosses_list)
    RecyclerView tossesRecyclerView;

    @BindView(R.id.linearLayout)
    LinearLayout infoLayout;
    @BindView(R.id.begin_tour_icon)
    ImageView beginTourIcon;
    @BindView(R.id.begin_tour_title)
    TextView beginTourTitle;
    @BindView(R.id.begin_tour_content)
    TextView beginTourContent;

    ActiveTossesAdapter adapter;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater,
                             @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.begin_fragment, container, false);
        ButterKnife.bind(this, view);
        viewModel = ViewModelProviders.of(this).get(BeginViewModel.class);
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
        mEndTourProgressBar.setVisibility(View.INVISIBLE);

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

    private void initRecyclerView(List<StoredToss> registeredCatch) {

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity());
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        DividerItemDecoration dividerItemDecoration = new DividerItemDecoration(tossesRecyclerView.getContext(),
                linearLayoutManager.getOrientation());
        dividerItemDecoration.setDrawable(getContext().getDrawable(R.drawable.active_toss_divider_shape));
        tossesRecyclerView.addItemDecoration(dividerItemDecoration);
        tossesRecyclerView.setLayoutManager(linearLayoutManager);
        adapter = new ActiveTossesAdapter(registeredCatch, this, getActivity());
        //adapter.setListener(this);
        tossesRecyclerView.setAdapter(adapter);
    }

    @Override
    public void displayError(String message, boolean isError) {
        super.displayError(message, isError);
        mEndTourProgressBar.setVisibility(View.INVISIBLE);
    }

    public void setUI() {
        // TODO: Change UI to match first screens
        if (Persistence.getBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP)) {
            if(storedTossArrayList.isEmpty()) {
                infoLayout.setVisibility(View.VISIBLE);
                tossesRecyclerView.setVisibility(View.GONE);
                beginTourIcon.setImageDrawable(getResources().getDrawable(R.drawable.ic_net_new));
                beginTourTitle.setVisibility(View.VISIBLE);
                beginTourContent.setVisibility(View.VISIBLE);
                beginTourContent.setText(R.string.tour_toss_add);
            } else {
                infoLayout.setVisibility(View.GONE);
                tossesRecyclerView.setVisibility(View.VISIBLE);
            }
            // tourActionButton.setText(R.string.new_stop_tour_nav);
        } else {
            infoLayout.setVisibility(View.VISIBLE);
            tossesRecyclerView.setVisibility(View.GONE);
            beginTourIcon.setImageDrawable(getResources().getDrawable(R.drawable.ic_fishing_hook));
            beginTourTitle.setVisibility(View.GONE);
            beginTourContent.setVisibility(View.VISIBLE);
            beginTourContent.setText(R.string.fishing_tour_info);
            // tourActionButton.setText(R.string.new_start_tour_nav);
        }
    }

    public void promptRegisterCatchDialog() {
        if (this.getActivity() != null) {
            new RegisterCatchDialog(this).show();
        }
    }

    /**
     * Shows a dialog list of all the tosses that have been laid out
     */
    private void generateSelectTossDialog() {
        if (storedTossArrayList.size() == 0) {
            displayError(getString(R.string.no_equipment_error), true);
            return;
        }

        new SelectTossDialog(this, storedTossArrayList, this::showTossInfo).show();
    }

    /**
     * Shows a dialog that requests the user to insert the amount of
     * fishing equipment he will toss out
     */
    private void promptTossOutEquipmentDialog() {
        String tourType = getTourType();
        new TossOutDialog(this, tourType).show();
    }

    public void registerNetTossOut(String amount) {
        String json = Persistence.getStringValue(Persistence.KEY_CURRENT_ACTIVE_TRIP);
        StartTourResponse tour = GsonInstance.sInstance.fromJson(json, StartTourResponse.class);
        viewModel.registerTossOut(Utils.getCurrentTourId(), UUID.randomUUID().toString(),
                generateTossBody(amount), tour.getFishingEquipment().getFishingEquipmentTypeId());
    }

    /**
     * Shows a dialog that requests the user to insert the number of
     * fishing equipment he will pull in from the selected toss
     *
     * @param toss
     */
    public void promptPullInDialog(StoredToss toss) {
        if (toss.getCount() - toss.getPulledCount() < 0) {
            displayError(getString(R.string.all_equipment_pulled_error), true);
        } else {
            String type = getTossType(toss);
            if (type.compareTo(FishingEquipments.HAND) == 0) {
                new PullHandDialog(this, toss).show();
            } else {
                new PullNetOrLineDialog(this, toss).show();
            }
        }
    }

    public void registerNetPullIn(StoredToss storedToss, String amount) {
        // TODO: change
        ((BaseActivity) getActivity()).setPromptDialogListener(this);
        viewModel.registerNewPullInData(storedToss.getId(), amount, storedToss.getEquipmentTypeId());
    }

    private void showTossInfo(final StoredToss toss) {
        new TossInfoDialog(this, toss).show();
    }

    /**
     * Generates a Toss body for the registerToss API call
     *
     * @param amount
     * @return RegisterTossBody
     */
    private RegisterTossBody generateTossBody(String amount) {
        RegisterTossBody tossBody = new RegisterTossBody();
        tossBody.setCount(Integer.parseInt(amount));
        tossBody.setDateTime(Utils.getRegistryTodayDate());
        Location location = ((MainActivity) getActivity()).getLastKnownLocation();
        if (location != null) {
            tossBody.setLatitude(location.getLatitude());
            tossBody.setLongitude(location.getLongitude());
        }
        return tossBody;
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
    public void onActionClicked(View view) {
        if (Persistence.getBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP)) {
            switch (view.getId()) {
                case R.id.pull_equipment_button:
                    generateSelectTossDialog();
                    break;
                default:
                    // promptStopTourDialog();
                    promptTossOutEquipmentDialog();
                    //String tourType = getTourType();
                    //new TossOutDialog(this, tourType).show();
                    break;
            }

        } else {
            Intent intent = new Intent(this.getContext(), StartTourActivity.class);
            startActivity(intent);
        }
    }

    public void promptDialog() {
        promptRegisterCatchDialog();
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
}
