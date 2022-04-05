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

package is.stokkur.afladagbok.android.statistics;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.fragment.app.Fragment;

import java.util.ArrayList;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.schedulers.Schedulers;
import is.stokkur.afladagbok.android.api.Client;
import is.stokkur.afladagbok.android.base.BaseViewModel;
import is.stokkur.afladagbok.android.models.History;
import is.stokkur.afladagbok.android.models.StatisticHistoryResponse;
import is.stokkur.afladagbok.android.models.StatisticResponse;
import is.stokkur.afladagbok.android.models.StatisticsDetailResponse;
import is.stokkur.afladagbok.android.statistics.lastTrip.LastTripStatisticsFragment;
import is.stokkur.afladagbok.android.statistics.pastTours.PastStatisticChildFragment;
import is.stokkur.afladagbok.android.statistics.pastTours.PastStatisticsFragment;
import is.stokkur.afladagbok.android.statistics.timePeriod.TimePeriodStatisticChildFragment;

/**
 * Created by annalaufey on 1/10/18.
 */

public class StatisticViewModel extends BaseViewModel {
    private final MutableLiveData<StatisticsDetailResponse> statisticsMutableLiveData = new MutableLiveData<>();
    private final MutableLiveData<StatisticHistoryResponse> statisticsHistoryMutableLiveData = new MutableLiveData<>();
    private final MutableLiveData<StatisticsDetailResponse> statisticsDetailMutableLiveData = new MutableLiveData<>();
    public Fragment mView = null;
    public StatisticActivity mActivity = null;
    private CompositeDisposable compositeDisposable;

    public StatisticViewModel() {
        this.compositeDisposable = new CompositeDisposable();
    }

    public void getStatisticsByDate(String dateFrom, String dateTo, String shipId) {
        compositeDisposable.add(Client.sharedClient().getClientInterface()
                .getStatisticsByDate(dateFrom, dateTo, shipId)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(this::onSuccess, this::onError));
    }

    public void getStatisticHistory(int page, int size, String shipId) {
        compositeDisposable.add(Client.sharedClient().getClientInterface()
                .getStatisticHistory(page, size, shipId)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(this::onSuccess, this::onError));
    }

    public void getStatisticDetail(int id) {
        compositeDisposable.add(Client.sharedClient().getClientInterface()
                .getStatisticDetail(id)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(this::onSuccess, this::onError));
    }

    private void onSuccess(StatisticsDetailResponse statisticsDetailResponse) {
        statisticsDetailMutableLiveData.setValue(statisticsDetailResponse);
        if (mView instanceof LastTripStatisticsFragment) {
            ((LastTripStatisticsFragment) mView).handleStatisticDetailResponse(statisticsDetailResponse);
        }
        if (mView instanceof PastStatisticChildFragment) {
            ((PastStatisticChildFragment) mView).handleStatisticDetailResponse(statisticsDetailResponse);
        }
    }

    private void onSuccess(StatisticHistoryResponse statisticHistoryResponse) {
        statisticsHistoryMutableLiveData.setValue(statisticHistoryResponse);
        if (mView instanceof LastTripStatisticsFragment) {
            ArrayList<History> history = statisticHistoryResponse.getHistory();
            if (history.size() > 0) {
                getStatisticDetail(history.get(0).getId());
            } else {
                ((LastTripStatisticsFragment) mView).hideProgressBar();
            }
        }
        if (mView instanceof PastStatisticsFragment) {
            ((PastStatisticsFragment) mView).handleStatisticHistoryResponse(statisticHistoryResponse);
        }
        if (mView == null && mActivity != null){
            if( statisticHistoryResponse.getHistory().size() > 0 ) {
                mActivity.shipHasCatchesRegistered();
            } else {
                mActivity.shipHasNoCatchesRegistered();
            }
        }
    }

    private void onSuccess(StatisticResponse statisticResponse) {
        if (mView instanceof TimePeriodStatisticChildFragment) {
            ((TimePeriodStatisticChildFragment) mView).handleStatisticDetailResponse(statisticResponse);
        }
    }

    public LiveData<StatisticsDetailResponse> returnStatisticsByDate() {
        return statisticsMutableLiveData;
    }

    public LiveData<StatisticHistoryResponse> returnStatisticHistoryResponse() {
        return statisticsHistoryMutableLiveData;
    }

    public LiveData<StatisticsDetailResponse> returnStatisticsDetailMutableLiveDataResponse() {
        return statisticsDetailMutableLiveData;
    }

}
