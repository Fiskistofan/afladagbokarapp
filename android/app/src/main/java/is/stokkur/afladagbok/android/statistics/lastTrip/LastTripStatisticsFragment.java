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

package is.stokkur.afladagbok.android.statistics.lastTrip;

import androidx.lifecycle.ViewModelProviders;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.models.StatisticsDetailResponse;
import is.stokkur.afladagbok.android.models.TourCatchDetailDto;
import is.stokkur.afladagbok.android.statistics.StatisticHelper;
import is.stokkur.afladagbok.android.statistics.StatisticViewModel;
import is.stokkur.afladagbok.android.utils.Persistence;
import is.stokkur.afladagbok.android.utils.Utils;

/**
 * Created by annalaufey on 11/22/17.
 */

public class LastTripStatisticsFragment
        extends BaseFragment {

    @BindView(R.id.statistics_layout)
    LinearLayout statisticsLayout;
    @BindView(R.id.statistics_list_layout)
    LinearLayout statisticsList;
    @BindView(R.id.harbor_txt)
    TextView harborTxt;
    @BindView(R.id.date_of_trip_txt)
    TextView dateOfTripTxt;
    @BindView(R.id.total_catch_txt)
    TextView totalCatchtxt;
    @BindView(R.id.total_species_txt)
    TextView totalSpeciesTxt;
    @BindView(R.id.total_registrations_txt)
    TextView totalRegistrationTxt;
    @BindView(R.id.last_trip_progress_bar)
    ProgressBar progressBar;
    @BindView(R.id.statistics_detail_layout)
    LinearLayout statistcsDetailLayot;
    @BindView(R.id.no_statistics_view)
    LinearLayout noStatisticsView;
    StatisticViewModel viewModel;

    public static LastTripStatisticsFragment newInstance() {
        return new LastTripStatisticsFragment();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.last_trip_statistics_fragment, container, false);
        ButterKnife.bind(this, view);
        viewModel = ViewModelProviders.of(this).get(StatisticViewModel.class);
        viewModel.mView = this;

        showProgressBar();
        viewModel.getStatisticHistory(0, 1, Persistence.getStringValue(Persistence.KEY_CURRENT_BOAT_ID));
        viewModel.getError().observe(this, errorWrapper -> {
            if (errorWrapper != null && errorWrapper.getThrowable() != null) {
                displayError(errorWrapper.getThrowable().getMessage(), true);
            } else {
                displayError(getString(R.string.general_error), true);
            }
            hideProgressBar();
        });
        return view;
    }

    public void handleStatisticDetailResponse(StatisticsDetailResponse response) {
        TourCatchDetailDto tourCatchDetailDto = response.getTourCatchDetailDto();
        noStatisticsView.setVisibility(View.GONE);
        statistcsDetailLayot.setVisibility(View.VISIBLE);
        harborTxt.setText(tourCatchDetailDto.getLandingPort());
        dateOfTripTxt.setText(Utils.getFormattedStringFromDate(tourCatchDetailDto.getLandingDate()));
        double totalWeight = tourCatchDetailDto.getCatchSum();
        totalCatchtxt.setText(getResources().getString(R.string.kg_txt, totalWeight));
        totalSpeciesTxt.setText(String.valueOf((int) tourCatchDetailDto.getSpeciesCount()));
        totalRegistrationTxt.setText(String.valueOf((int) tourCatchDetailDto.getTotalPulls()));
        StatisticHelper.addLayouts(tourCatchDetailDto.getFishSpeciesTotalCatchList(),
                tourCatchDetailDto.getMammalAndBirdsTotalCatchList(),
                totalWeight, statisticsLayout, statisticsList, getActivity());
        hideProgressBar();
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

}
