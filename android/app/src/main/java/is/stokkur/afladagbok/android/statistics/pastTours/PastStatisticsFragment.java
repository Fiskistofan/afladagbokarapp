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

import android.annotation.SuppressLint;
import androidx.lifecycle.ViewModelProviders;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ProgressBar;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.models.History;
import is.stokkur.afladagbok.android.models.StatisticHistoryResponse;
import is.stokkur.afladagbok.android.statistics.PageFragmentListener;
import is.stokkur.afladagbok.android.statistics.StatisticViewModel;
import is.stokkur.afladagbok.android.utils.Persistence;

/**
 * Created by annalaufey on 11/22/17.
 */
@SuppressLint("ValidFragment")
public class PastStatisticsFragment extends BaseFragment implements PastStatisticSelectListener {

    @BindView(R.id.past_tours_recycler_view)
    RecyclerView pastTourRecyclerView;
    @BindView(R.id.past_statistics_progress_bar)
    ProgressBar progressBar;
    @BindView(R.id.no_statistics_view)
    LinearLayout noStatisticsView;
    PastTourAdapter adapter;
    StatisticViewModel viewModel;

    public PastStatisticsFragment() {
    }

    public PastStatisticsFragment(PageFragmentListener listener) {
        pageFragmentListener = listener;
    }


    public static PastStatisticsFragment newInstance(PageFragmentListener listener) {
        return new PastStatisticsFragment(listener);

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.past_statistics_fragment, container, false);
        ButterKnife.bind(this, view);
        viewModel = ViewModelProviders.of(this).get(StatisticViewModel.class);
        viewModel.mView = this;

        showProgressBar();
        viewModel.getStatisticHistory(0, 10, Persistence.getStringValue(Persistence.KEY_CURRENT_BOAT_ID));
        viewModel.getError().observe(this, errorWrapper -> {
            if (errorWrapper != null && errorWrapper.getThrowable() != null) {
                displayError(errorWrapper.getThrowable().getMessage(), true);
            } else {
                displayError(getResources().getString(R.string.general_error), true);
            }
            hideProgressBar();
        });

        return view;
    }

    /**
     * Initialize the scroll view
     *
     * @param tours
     */
    private void initRecyclerView(List<History> tours) {
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity());
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        pastTourRecyclerView.setLayoutManager(linearLayoutManager);
        adapter = new PastTourAdapter(tours, getActivity());
        adapter.setListener(this);
        pastTourRecyclerView.setAdapter(adapter);
    }

    @Override
    public void onSelectTour(int tourId) {
        if (pageFragmentListener != null) {
            pageFragmentListener.onSwitchToNextFragment(tourId);
        }
    }

    public void handleStatisticHistoryResponse(StatisticHistoryResponse statisticHistoryResponse) {
        if (statisticHistoryResponse != null) {
            ArrayList<History> history = statisticHistoryResponse.getHistory();
            noStatisticsView.setVisibility(history.size() > 0 ? View.GONE : View.VISIBLE);
            initRecyclerView(history);
            hideProgressBar();
        }
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
