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

package is.stokkur.afladagbok.android.tour;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.lifecycle.ViewModelProviders;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import is.stokkur.afladagbok.android.ActionListener;
import is.stokkur.afladagbok.android.AfladagbokApplication;
import is.stokkur.afladagbok.android.MainActivity;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseActivity;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.dialogs.PromptDialogListener;
import is.stokkur.afladagbok.android.dialogs.PullHandDialog;
import is.stokkur.afladagbok.android.dialogs.PullHandRegistrable;
import is.stokkur.afladagbok.android.dialogs.PullNetOrLineDialog;
import is.stokkur.afladagbok.android.dialogs.PullNetOrLineRegistrable;
import is.stokkur.afladagbok.android.dialogs.RegisterCatchDialog;
import is.stokkur.afladagbok.android.dialogs.SelectTossDialog;
import is.stokkur.afladagbok.android.dialogs.StopTourDialog;
import is.stokkur.afladagbok.android.dialogs.StopTourListener;
import is.stokkur.afladagbok.android.dialogs.TossInfoDialog;
import is.stokkur.afladagbok.android.dialogs.TossInfoHandler;
import is.stokkur.afladagbok.android.dialogs.TossOutDialog;
import is.stokkur.afladagbok.android.dialogs.TossOutListener;
import is.stokkur.afladagbok.android.models.FishingEquipments;
import is.stokkur.afladagbok.android.models.RegisterTossBody;
import is.stokkur.afladagbok.android.models.StartTourResponse;
import is.stokkur.afladagbok.android.utils.GsonInstance;
import is.stokkur.afladagbok.android.utils.Persistence;
import is.stokkur.afladagbok.android.utils.Utils;

import static is.stokkur.afladagbok.android.utils.Utils.getTossType;
import static is.stokkur.afladagbok.android.utils.Utils.getTourType;

/**
 * Created by annalaufey on 11/10/17.
 */

public class TourFragment
        extends BaseFragment
        implements TourActionButtonListener, PromptDialogListener, StopTourListener, TossOutListener,
        TossInfoHandler, PullHandRegistrable, PullNetOrLineRegistrable, ActionListener {

    TourViewModel viewModel;
    @BindView(R.id.tour_action_button)
    TextView tourActionButton;
    private List<StoredToss> storedTossArrayList;
    private ProgressBar mEndTourProgressBar;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater,
                             @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.tour_fragment, container, false);
        ButterKnife.bind(this, view);
        viewModel = ViewModelProviders.of(this).get(TourViewModel.class);
        viewModel.mView = this;
        viewModel.getError().observe(this, errorWrapper -> {
            if (errorWrapper != null && errorWrapper.getThrowable() != null) {
                showError(errorWrapper.getThrowable().getMessage(), true);
            } else {
                showError(getResources().getString(R.string.general_error), true);
            }
        });
        storedTossArrayList = new ArrayList<>();

        return view;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        mEndTourProgressBar = view.findViewById(R.id.end_tour_progress);
        mEndTourProgressBar.setVisibility(View.INVISIBLE);

    }

    @Override
    public void onButtonClicked(View button) {
        switch (button.getId()) {
            case R.id.toss_out_button:
                promptTossOutEquipmentDialog();
                break;
            case R.id.pull_equipment_button:
                generateSelectTossDialog();
                break;
            case R.id.tour_action_button:
                promptStopTourDialog();
                break;
        }
    }

    @SuppressLint("CheckResult")
    @Override
    public void onResume() {
        super.onResume();
        setTourActionButton();
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

    @OnClick(R.id.tour_action_button)
    public void tourActionClicked(View v) {
        //((MainActivity) getActivity()).tourActionClicked(v);
        setTourActionButton();
    }

    /**
     * Resets the action button depending if the tour is active or not
     */
    public void setTourActionButton() {
        if (Persistence.getBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP)) {
            tourActionButton.setText(R.string.new_stop_tour_nav);
        } else {
            tourActionButton.setText(R.string.new_start_tour_nav);
        }
    }

    /**
     * Shows a dialog that asks if you are sure if you want to stop the tour
     */
    private void promptStopTourDialog() {
        new StopTourDialog(this).show();
    }

    public void promptRegisterCatchDialog() {
        new RegisterCatchDialog(this).show();
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
        ((BaseActivity) getActivity()).setPromptDialogListener(this);
        viewModel.registerNewPullInData(storedToss.getId(), amount, storedToss.getEquipmentTypeId());
    }

    private void showTossInfo(final StoredToss toss) {
        new TossInfoDialog(this, toss).show();
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
        tourActionButton.setText(R.string.new_start_tour_nav);
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
        tossBody.setLatitude(((MainActivity) getActivity()).getLastKnownLocation().getLatitude());
        tossBody.setLongitude(((MainActivity) getActivity()).getLastKnownLocation().getLongitude());
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
                    storedTossArrayList = storedTosses;
                }
            });
        }
    }

    @Override
    public void promptDialog() {
        promptRegisterCatchDialog();
    }

    @Override
    public void onActionClicked(View view) {
        onButtonClicked(view);
    }
}


