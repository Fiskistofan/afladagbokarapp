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

package is.stokkur.afladagbok.android.services;

import com.firebase.jobdispatcher.JobParameters;
import com.firebase.jobdispatcher.SimpleJobService;

import java.util.List;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.schedulers.Schedulers;
import is.stokkur.afladagbok.android.AfladagbokApplication;
import is.stokkur.afladagbok.android.DataRepository;
import is.stokkur.afladagbok.android.api.Client;
import is.stokkur.afladagbok.android.db.entity.StoredAnimalCatch;
import is.stokkur.afladagbok.android.db.entity.StoredFishCatch;
import is.stokkur.afladagbok.android.db.entity.StoredPull;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.models.RegisterAnimalCatchBody;
import is.stokkur.afladagbok.android.models.RegisterAnimalCatchResponse;
import is.stokkur.afladagbok.android.models.RegisterFishCatchBody;
import is.stokkur.afladagbok.android.models.RegisterFishCatchResponse;
import is.stokkur.afladagbok.android.models.RegisterPullBody;
import is.stokkur.afladagbok.android.models.RegisterPullResponse;
import is.stokkur.afladagbok.android.models.RegisterTossBody;
import is.stokkur.afladagbok.android.models.RegisterTossResponse;
import is.stokkur.afladagbok.android.utils.Utils;

/**
 * Created by annalaufey on 2/20/18.
 */
public class SyncJobService extends SimpleJobService {

    private final DataRepository mRepository = AfladagbokApplication.getInstance().getRepository();
    private CompositeDisposable compositeDisposable = new CompositeDisposable();

    @Override
    public int onRunJob(JobParameters job) {
        List<StoredPull> storedPullList = mRepository.getStoredUnsavedPull();
        List<StoredToss> storedTossList = mRepository.getStoredUnsavedToss();
        List<StoredFishCatch> storedFishCatchList = mRepository.getStoredUnsavedFishCatch();
        List<StoredAnimalCatch> storedAnimalCatchList = mRepository.getStoredUnsavedAnimalCatch();
        if (storedPullList.size() == 0
                && storedTossList.size() == 0
                && storedFishCatchList.size() == 0
                && storedAnimalCatchList.size() == 0) {
            return RESULT_SUCCESS;
        }

        for (StoredPull storedPull : storedPullList) {
            RegisterPullBody pullBody = new RegisterPullBody(storedPull.getCount(),
                    storedPull.getDateTime(), storedPull.getTossId());
            sendPullToBackend(Utils.getCurrentTourId(), storedPull.getPullId(), pullBody);
        }

        for (StoredToss storedToss : storedTossList) {
            RegisterTossBody tossBody = new RegisterTossBody(storedToss.getDateTime(),
                    storedToss.getLatitude(), storedToss.getLongitude(), storedToss.getCount());
            sendTossToBackend(Utils.getCurrentTourId(), storedToss.getTossId(), tossBody);
        }

        for (StoredFishCatch fishCatch : storedFishCatchList) {
            RegisterFishCatchBody catchBody = new RegisterFishCatchBody(fishCatch.getWeight(),
                    fishCatch.getFishSpeciesId(), fishCatch.isGutted(), fishCatch.isReleased(),
                    fishCatch.isSmallFish(), fishCatch.getLatitude(), fishCatch.getLongitude(),
                    fishCatch.getPullId());
            registerCaughtFishInTour(Utils.getCurrentTourId(), fishCatch.getCatchId(), catchBody);
        }

        for (StoredAnimalCatch animalCatch : storedAnimalCatchList) {
            RegisterAnimalCatchBody catchBody = new RegisterAnimalCatchBody(
                    animalCatch.getOtherSpeciesId(), animalCatch.getCount(),
                    animalCatch.getLatitude(), animalCatch.getLongitude(), animalCatch.getPullId());
            registerCaughtAnimalsInTour(Utils.getCurrentTourId(), animalCatch.getCatchId(),
                    catchBody);
        }

        return RESULT_FAIL_RETRY;
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
     * Marks a toss that it has been successfully stored in backend
     *
     * @param registerTossResponse
     */
    private void onSuccess(RegisterTossResponse registerTossResponse) {
        mRepository.markTossAsStored(registerTossResponse.getToss().getId());
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
     * Marks a pull that it has been successfully stored in backend
     *
     * @param registerPullResponse
     */
    private void onSuccess(RegisterPullResponse registerPullResponse) {
        mRepository.markPullAsStored(registerPullResponse.getPull().getId());
    }

    /**
     * Saves stored fish catch in backend
     *
     * @param tourId
     * @param orderSpeciesCatchId
     * @param registerCatchBody
     */
    public void registerCaughtFishInTour(int tourId, String orderSpeciesCatchId,
                                         RegisterFishCatchBody registerCatchBody) {
        if (Utils.isNetworkAvailable()) {
            compositeDisposable.add(Client.sharedClient().getClientInterface()
                    .registerCaughtFish(tourId, orderSpeciesCatchId, registerCatchBody)
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(this::onSuccess, this::onError));
        }
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
    public void registerCaughtAnimalsInTour(int tourId, String orderSpeciesCatchId,
                                            RegisterAnimalCatchBody registerCatchBody) {
        if (Utils.isNetworkAvailable()) {
            compositeDisposable.add(Client.sharedClient().getClientInterface()
                    .registerCaughtAnimals(tourId, orderSpeciesCatchId, registerCatchBody)
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(this::onSuccess, this::onError));
        }
    }

    private void onSuccess(RegisterAnimalCatchResponse registerAnimalCatchResponse) {
        mRepository.markAnimalCatchAsStored(
                registerAnimalCatchResponse.getRegisteredAnimalCatch().getId());
    }

    private void onError(Throwable throwable) {
    }

}
