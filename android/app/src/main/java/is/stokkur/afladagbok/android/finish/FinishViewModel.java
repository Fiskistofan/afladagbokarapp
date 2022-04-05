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

import android.os.AsyncTask;

import androidx.fragment.app.Fragment;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;

import java.util.List;
import java.util.UUID;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.schedulers.Schedulers;
import is.stokkur.afladagbok.android.AfladagbokApplication;
import is.stokkur.afladagbok.android.DataRepository;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.api.Client;
import is.stokkur.afladagbok.android.base.BaseViewModel;
import is.stokkur.afladagbok.android.db.entity.StoredAnimalCatch;
import is.stokkur.afladagbok.android.db.entity.StoredFishCatch;
import is.stokkur.afladagbok.android.db.entity.StoredPull;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.db.entity.TripLocation;
import is.stokkur.afladagbok.android.dialogs.ErrorDisplayable;
import is.stokkur.afladagbok.android.models.ConfirmTourResponse;
import is.stokkur.afladagbok.android.models.RegisterAnimalCatchBody;
import is.stokkur.afladagbok.android.models.RegisterAnimalCatchResponse;
import is.stokkur.afladagbok.android.models.RegisterFishCatchBody;
import is.stokkur.afladagbok.android.models.RegisterFishCatchResponse;
import is.stokkur.afladagbok.android.models.RegisterPullBody;
import is.stokkur.afladagbok.android.models.RegisterPullResponse;
import is.stokkur.afladagbok.android.models.RegisterTossBody;
import is.stokkur.afladagbok.android.models.RegisterTossResponse;
import is.stokkur.afladagbok.android.models.StatisticsDetailResponse;
import is.stokkur.afladagbok.android.utils.Persistence;
import is.stokkur.afladagbok.android.utils.Utils;

public class FinishViewModel extends BaseViewModel {
    private final DataRepository mRepository;
    public Fragment mView = null;
    private final MutableLiveData<StatisticsDetailResponse> statisticsDetailMutableLiveData = new MutableLiveData<>();
    private CompositeDisposable compositeDisposable;

    public FinishViewModel() {
        this.compositeDisposable = new CompositeDisposable();
        this.mRepository = AfladagbokApplication.getInstance().getRepository();

    }

    /**
     * Checks if all of the stored tosses, pulls and catches have been sent to the backend.
     *
     * @param tourId
     */
    public void confirmTour(int tourId) {
        AsyncTask.execute(() -> {
            if (getUnsavedStoredToss() == 0
                    && getUnsavedStoredPull() == 0
                    && getUnsavedStoredFishCatch() == 0
                    && getUnsavedStoredAnimalCatch() == 0) {
                registerConfirmTour(tourId);
            } else {
                ((ErrorDisplayable) mView).showError(AfladagbokApplication.getAppContext().getResources().getString(R.string.catch_not_sent_to_backend_error), true);
                syncTourWithBackend();
            }
        });
    }

    /**
     * Syncs all the pulls, tosses, and catches with the backend before
     * the user can confirm the tour
     */
    private void syncTourWithBackend() {
        AsyncTask.execute(() -> {
            List<StoredPull> storedPullList = mRepository.getStoredUnsavedPull();
            for (StoredPull storedPull : storedPullList) {
                RegisterPullBody pullBody = new RegisterPullBody(storedPull.getCount(), storedPull.getDateTime(), storedPull.getTossId());
                sendPullToBackend(Utils.getCurrentTourId(), storedPull.getPullId(), pullBody);
            }

            List<StoredToss> storedTossList = mRepository.getStoredUnsavedToss();
            for (StoredToss storedToss : storedTossList) {
                RegisterTossBody tossBody = new RegisterTossBody(storedToss.getDateTime(), storedToss.getLatitude(), storedToss.getLongitude(), storedToss.getCount());
                sendTossToBackend(Utils.getCurrentTourId(), storedToss.getTossId(), tossBody);
            }

            List<StoredFishCatch> storedFishCatchList = mRepository.getStoredUnsavedFishCatch();
            for (StoredFishCatch fishCatch : storedFishCatchList) {
                RegisterFishCatchBody catchBody = new RegisterFishCatchBody(fishCatch.getWeight(), fishCatch.getFishSpeciesId(), fishCatch.isGutted(), fishCatch.isReleased(), fishCatch.isSmallFish(), fishCatch.getLatitude(), fishCatch.getLongitude(), fishCatch.getPullId());
                registerCaughtFishInTour(Utils.getCurrentTourId(), fishCatch.getCatchId(), catchBody);
            }

            List<StoredAnimalCatch> storedAnimalCatchList = mRepository.getStoredUnsavedAnimalCatch();
            for (StoredAnimalCatch animalCatch : storedAnimalCatchList) {
                RegisterAnimalCatchBody catchBody = new RegisterAnimalCatchBody(animalCatch.getOtherSpeciesId(), animalCatch.getCount(), animalCatch.getLatitude(), animalCatch.getLongitude(), animalCatch.getPullId());
                registerCaughtAnimalsInTour(Utils.getCurrentTourId(), animalCatch.getCatchId(), catchBody);
            }
        });
    }


    /**
     * Sends the tour confirmation to the backend
     *
     * @param tourId
     */
    public void registerConfirmTour(int tourId) {
        compositeDisposable.add(Client.sharedClient().getClientInterface()
                .confirmTour(tourId)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(this::onSuccess, this::onError));
    }

    private void onSuccess(ConfirmTourResponse confirmTourResponse) {
        ((ErrorDisplayable) mView).showError(AfladagbokApplication.getAppContext().getResources().getString(R.string.tour_confirmed), false);
        mRepository.deleteAllData();
        Persistence.saveBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP, false);
        Persistence.saveStringValue(Persistence.KEY_CURRENT_ACTIVE_TRIP, null);
        ((FinishFragment) mView).endTour();
    }


    private void onSuccess(RegisterPullResponse registerPullResponse) {
        mRepository.markPullAsStored(registerPullResponse.getPull().getId());
    }

    private void onSuccess(RegisterTossResponse registerTossResponse) {
        mRepository.markTossAsStored(registerTossResponse.getToss().getId());
    }

    /**
     * Get a list of all the stored tosses in the database by tour
     *
     * @return
     */
    public LiveData<List<StoredToss>> getStoredToss() {
        return mRepository.getStoredToss();
    }

    /**
     * Get a number of unsaved stored toss
     *
     * @return
     */
    public int getUnsavedStoredToss() {
        return mRepository.getStoredUnsavedToss().size();
    }

    /**
     * Get a number of unsaved stored toss
     *
     * @return
     */
    public int getUnsavedStoredPull() {
        return mRepository.getStoredUnsavedPull().size();
    }

    /**
     * Get a number of unsaved stored toss
     *
     * @return
     */
    public int getUnsavedStoredFishCatch() {
        return mRepository.getStoredUnsavedFishCatch().size();
    }

    /**
     * Get a number of unsaved stored toss
     *
     * @return
     */
    public int getUnsavedStoredAnimalCatch() {
        return mRepository.getStoredUnsavedAnimalCatch().size();
    }

    /**
     * Retrieve the trip route
     *
     * @return LiveData for a List of TripLocation
     */
    public LiveData<List<TripLocation>> getTripRoute() {
        return mRepository.getTripRoute();
    }


    /**
     * Sends the toss to the backend
     *
     * @param tourId
     * @param tossId
     * @param tossBody
     */
    public void sendTossToBackend(int tourId, String tossId, RegisterTossBody tossBody) {
        if (Utils.isNetworkAvailable()) {
            compositeDisposable.add(Client.sharedClient().getClientInterface()
                    .registerToss(tourId, tossId, tossBody)
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(this::onSuccess, this::onError));
        }
    }

    /**
     * Saves the pull in the backend
     *
     * @param tourId
     * @param pullId
     * @param pullBody
     */
    public void sendPullToBackend(int tourId, String pullId, RegisterPullBody pullBody) {
        if (Utils.isNetworkAvailable()) {
            compositeDisposable.add(Client.sharedClient().getClientInterface()
                    .registerPull(tourId, pullId, pullBody)
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(this::onSuccess, this::onError));
        }
    }

    /**
     * Saves stored fish catch in backend
     *
     * @param tourId
     * @param orderSpeciesCatchId
     * @param registerCatchBody
     */
    public void registerCaughtFishInTour(int tourId, String orderSpeciesCatchId, RegisterFishCatchBody registerCatchBody) {
        compositeDisposable.add(Client.sharedClient().getClientInterface()
                .registerCaughtFish(tourId, orderSpeciesCatchId, registerCatchBody)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(this::onSuccess, this::onError));
    }

    /**
     * Marks a fish catch that it has been successfully stored in backend
     *
     * @param registerFishCatchResponse
     */
    private void onSuccess(RegisterFishCatchResponse registerFishCatchResponse) {
        mRepository.markFishCatchAsStored(registerFishCatchResponse.getaCatch().getId());
    }

    /**
     * Saves stored animal catch in backend
     *
     * @param tourId
     * @param orderSpeciesCatchId
     * @param registerCatchBody
     */
    public void registerCaughtAnimalsInTour(int tourId, String orderSpeciesCatchId, RegisterAnimalCatchBody registerCatchBody) {
        compositeDisposable.add(Client.sharedClient().getClientInterface()
                .registerCaughtAnimals(tourId, orderSpeciesCatchId, registerCatchBody)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(this::onSuccess, this::onError));
    }

    private void onSuccess(RegisterAnimalCatchResponse registerAnimalCatchResponse) {
        mRepository.markAnimalCatchAsStored(registerAnimalCatchResponse.getRegisteredAnimalCatch().getId());
    }

    /**
     * Gets the stored toss that the user selected and generates a pullId from that toss
     *
     * @param id
     * @param amount
     */
    public void registerNewPullInData(int id, String amount, int equipmentTypeId) {
        AsyncTask.execute(() -> {
            StoredToss s = getSelectedStoredToss(id);
            if (Integer.parseInt(amount) > s.getCount() - s.getPulledCount()) {
                ((ErrorDisplayable) mView).showError(AfladagbokApplication.getAppContext().getResources().getString(R.string.cannot_pull_in_more_error, s.getCount() - s.getPulledCount()), true);
                return;
            }

            String tossTypeName = Utils.getShortNameForType(mView.getContext(), Utils.getTypeForTypeId(equipmentTypeId));
            ((ErrorDisplayable) mView).displayError(
                    AfladagbokApplication.getAppContext().getResources().getString(
                            R.string.pulled_in_amount_message,
                            Integer.parseInt(amount),
                            s.getCount() - s.getPulledCount(),
                            tossTypeName,
                            s.getCount() - s.getPulledCount() - Integer.parseInt(amount)
                    ), false
            );
            registerPullIn(Utils.getCurrentTourId(), UUID.randomUUID().toString(),
                    generatePullBody(amount, s), equipmentTypeId);
        });

    }

    /**
     * Gets the stored toss by id
     *
     * @param id
     * @return
     */
    public StoredToss getSelectedStoredToss(int id) {
        return mRepository.getSelectedToss(id);
    }

    /**
     * Saves the Pull in the database and sends it to the backend
     *
     * @param tourId
     * @param pullId
     * @param pullBody
     * @param equipmentTypeId
     */
    public void registerPullIn(int tourId, String pullId, RegisterPullBody pullBody,
                               int equipmentTypeId) {
        StoredPull storedPull = new StoredPull(tourId, pullBody.getTossId(), pullId,
                pullBody.getDatePulled(), pullBody.getCount(), equipmentTypeId);
        mRepository.saveStoredPull(storedPull);
        mRepository.setPulledCountInToss(pullBody.getCount(), pullBody.getTossId());
        sendPullToBackend(tourId, pullId, pullBody);
    }

    /**
     * Generates the pull body for the API request
     *
     * @param amount
     * @param storedToss
     * @return RegisterPullBody
     */
    private RegisterPullBody generatePullBody(String amount, StoredToss storedToss) {
        RegisterPullBody registerPullBody = new RegisterPullBody();
        registerPullBody.setCount(Integer.parseInt(amount));
        registerPullBody.setDatePulled(Utils.getRegistryTodayDate());
        registerPullBody.setTossId(storedToss.getTossId());
        return registerPullBody;
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
        if (mView instanceof FinishFragment) {
            ((FinishFragment) mView).handleStatisticDetailResponse(statisticsDetailResponse);
        }
    }

}
