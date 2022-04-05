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

package is.stokkur.afladagbok.android.statistics.pastTours;

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
import is.stokkur.afladagbok.android.utils.Utils;

/**
 * Created by annalaufey on 12/19/17.
 */

public class PastStatisticChildFragment extends BaseFragment {

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
    @BindView(R.id.past_statistics_detail_progress_bar)
    ProgressBar progressBar;
    @BindView(R.id.statistics_detail_layout)
    LinearLayout statisticsDetailLayout;
    StatisticViewModel viewModel;

    private int tourId;

    public static PastStatisticChildFragment newInstance() {
        return new PastStatisticChildFragment();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.past_statistic_child_fragment, container, false);
        ButterKnife.bind(this, view);
        viewModel = ViewModelProviders.of(this).get(StatisticViewModel.class);
        viewModel.mView = this;

        showProgressBar();
        viewModel.getStatisticDetail(tourId);
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
        statisticsDetailLayout.setVisibility(View.VISIBLE);
        TourCatchDetailDto tourCatchDetailDto = response.getTourCatchDetailDto();
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
    public int getChildSelectedId() {
        return super.getChildSelectedId();
    }

    @Override
    public void setChildSelectedId(int id) {
        tourId = id;
        super.setChildSelectedId(id);
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
