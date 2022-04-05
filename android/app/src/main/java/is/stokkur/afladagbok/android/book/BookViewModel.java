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

package is.stokkur.afladagbok.android.book;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MediatorLiveData;
import androidx.lifecycle.MutableLiveData;
import android.location.Location;
import androidx.fragment.app.Fragment;

import java.util.ArrayList;
import java.util.List;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.schedulers.Schedulers;
import is.stokkur.afladagbok.android.AfladagbokApplication;
import is.stokkur.afladagbok.android.DataRepository;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.api.Client;
import is.stokkur.afladagbok.android.base.BaseViewModel;
import is.stokkur.afladagbok.android.db.entity.SoredPullWithCatchInfo;
import is.stokkur.afladagbok.android.db.entity.StoredAnimalCatch;
import is.stokkur.afladagbok.android.db.entity.StoredFishCatch;
import is.stokkur.afladagbok.android.db.entity.StoredPull;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.models.ProfileResponse;
import is.stokkur.afladagbok.android.models.RegisterAnimalCatchBody;
import is.stokkur.afladagbok.android.models.RegisterAnimalCatchResponse;
import is.stokkur.afladagbok.android.models.RegisterFishCatchBody;
import is.stokkur.afladagbok.android.models.RegisterFishCatchResponse;
import is.stokkur.afladagbok.android.models.Species;
import is.stokkur.afladagbok.android.models.StartTourResponse;
import is.stokkur.afladagbok.android.utils.GsonInstance;
import is.stokkur.afladagbok.android.utils.Persistence;
import is.stokkur.afladagbok.android.utils.SpeciesID;
import is.stokkur.afladagbok.android.utils.Utils;

/**
 * Created by annalaufey on 11/14/17.
 */

public class BookViewModel extends BaseViewModel {

    private final DataRepository mRepository;
    private final MutableLiveData<Location> locationMutableLiveData = new MutableLiveData<>();
    public Fragment mView = null;
    private CompositeDisposable compositeDisposable;
    private MediatorLiveData<List<SoredPullWithCatchInfo>> mObservableStoredPullList;
    private MutableLiveData<StoredFishCatch> allFishCatchResponseMutableLiveData = new MutableLiveData<>();
    private List<StoredPull> StoredPulls;
    private int speciesId;
    private Species selectedSpecies;
    private int tourId;
    private String editCatchId;

    public BookViewModel() {
        this.compositeDisposable = new CompositeDisposable();
        this.mRepository = AfladagbokApplication.getInstance().getRepository();

        mObservableStoredPullList = new MediatorLiveData<>();
        mObservableStoredPullList.setValue(null);

        StartTourResponse startTourObject = GsonInstance.sInstance.
                fromJson(Persistence.getStringValue(Persistence.KEY_CURRENT_ACTIVE_TRIP),
                        StartTourResponse.class);
        if (startTourObject != null && startTourObject.getTour() != null) {
            tourId = startTourObject.getTour().getTourId();
            LiveData<List<SoredPullWithCatchInfo>> storedPull = mRepository.getAllSavedPulls(tourId);
            mObservableStoredPullList.addSource(storedPull, mObservableStoredPullList::setValue);
        }
    }

    /**
     * Returns all stored pulls in database
     *
     * @return
     */
    public LiveData<List<SoredPullWithCatchInfo>> getAllStoredPulls() {
        return mObservableStoredPullList;
    }

    /**
     * Generates a list of the available selection of species
     *
     * @return
     */
    public List<Species> generateSpecies() {
        List<Species> species = new ArrayList<>();
        species.add(new Species(SpeciesID.FISH, AfladagbokApplication.getAppContext().getResources().getString(R.string.fish)));
        species.add(new Species(SpeciesID.OTHER, AfladagbokApplication.getAppContext().getResources().getString(R.string.other_species_new)));
        return species;
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
        compositeDisposable.add(Client.sharedClient().getClientInterface()
                .registerCaughtAnimals(tourId, orderSpeciesCatchId, registerCatchBody)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(this::onSuccess, this::onError));
    }

    /**
     * Marks an animal catch that it has been successfully stored in backend
     *
     * @param registerAnimalCatchResponse
     */
    private void onSuccess(RegisterAnimalCatchResponse registerAnimalCatchResponse) {
        mRepository.markAnimalCatchAsStored(
                registerAnimalCatchResponse.getRegisteredAnimalCatch().getId());
    }

    /**
     * Saves stored fish catch to backend
     *
     * @param tourId
     * @param orderSpeciesCatchId
     * @param registerCatchBody
     */
    public void registerCaughtFishInTour(int tourId, String orderSpeciesCatchId,
                                         RegisterFishCatchBody registerCatchBody) {
        compositeDisposable.add(Client.sharedClient().getClientInterface()
                .registerCaughtFish(tourId, orderSpeciesCatchId, registerCatchBody)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(this::onSuccess, this::onError));
    }

    /**
     * Marks a fish catch that it has been successfully stored in backend
     *
     * @param registerCatchResponse
     */
    private void onSuccess(RegisterFishCatchResponse registerCatchResponse) {
        mRepository.markFishCatchAsStored(registerCatchResponse.getaCatch().getId());
    }

    /**
     * Saves caught animal to database
     *
     * @param species
     * @param orderSpeciesCatchId
     * @param registerCatchBody
     */
    public void saveCaughtAnimalToDatabase(Species species, String orderSpeciesCatchId,
                                           RegisterAnimalCatchBody registerCatchBody) {
        StoredAnimalCatch storedAnimalCatch = new StoredAnimalCatch(tourId,
                orderSpeciesCatchId,
                registerCatchBody.getOtherSpeciesId(),
                species.getSpeciesName(),
                Utils.getRegistryTodayDate(),
                false,
                registerCatchBody.getCount(),
                registerCatchBody.getLatitude(),
                registerCatchBody.getLongitude(),
                registerCatchBody.getPullId());
        mRepository.saveStoredAnimalCatch(storedAnimalCatch);
    }

    /**
     * Updates a caught animal in the database
     *
     * @param storedAnimalCatch
     */
    public void updateCaughtAnimal(StoredAnimalCatch storedAnimalCatch) {
        storedAnimalCatch.setId(0);
        storedAnimalCatch.setRegistryDate(Utils.getRegistryTodayDate());
        mRepository.saveStoredAnimalCatch(storedAnimalCatch);
    }

    /**
     * Saves a caught fish to the database
     *
     * @param species
     * @param orderSpeciesCatchId
     * @param registerCatchBody
     */
    public void saveCaughtFishToDatabase(Species species, String orderSpeciesCatchId,
                                         RegisterFishCatchBody registerCatchBody) {
        StoredFishCatch storedFishCatch = new StoredFishCatch(tourId,
                orderSpeciesCatchId,
                registerCatchBody.getFishSpeciesId(),
                species.getSpeciesName(),
                Utils.getRegistryTodayDate(),
                false,
                registerCatchBody.getWeight(),
                registerCatchBody.isGutted(),
                registerCatchBody.isReleased(),
                registerCatchBody.isSmallFish(),
                registerCatchBody.getLatitude(),
                registerCatchBody.getLongitude(),
                registerCatchBody.getPullId());
        mRepository.saveStoredFishCatch(storedFishCatch);
    }

    /**
     * Updates a caught fish in the database
     *
     * @param storedFishCatch
     */
    public void updateCaughtFish(StoredFishCatch storedFishCatch) {
        storedFishCatch.setId(0);
        storedFishCatch.setRegistryDate(Utils.getRegistryTodayDate());
        mRepository.saveStoredFishCatch(storedFishCatch);
    }

    public ArrayList<Species> getSpeciesList() {
        ArrayList<Species> species;
        ProfileResponse profile = GsonInstance.sInstance.
                fromJson(Persistence.getStringValue(Persistence.KEY_PROFILE), ProfileResponse.class);
        switch (speciesId) {
            case SpeciesID.FISH:
                species = profile.getFishSpecies();
                break;
            case SpeciesID.OTHER:
                species = profile.getOtherSpecies();
                break;
            default:
                species = profile.getFishSpecies();
                break;
        }
        return species;
    }

    public LiveData<List<StoredFishCatch>> getAllFishCatchForTour() {
        return mRepository.getAllStoredFishCatch(tourId);
    }

    public LiveData<List<StoredAnimalCatch>> getAllAnimalCatchForTour() {
        return mRepository.getAllStoredAnimalCatch(tourId);
    }

    public LiveData<StoredFishCatch> getFishCatchById(String catchId) {
        return mRepository.getStoredFishCatch(catchId);
    }

    public LiveData<StoredAnimalCatch> getAnimalCatchById(String catchId) {
        return mRepository.getStoredAnimalCatch(catchId);
    }

    public String getEditCatchId() {
        return editCatchId;
    }

    public void setEditCatchId(String editCatchId) {
        this.editCatchId = editCatchId;
    }

    public List<StoredPull> getStoredPulls() {
        return StoredPulls;
    }

    public void setStoredPulls(List<StoredPull> storedPulls) {
        StoredPulls = storedPulls;
    }

    public int getSpeciesId() {
        return speciesId;
    }

    public void setSpeciesId(int speciesId) {
        this.speciesId = speciesId;
    }

    public Species getSelectedSpecies() {
        return selectedSpecies;
    }

    public void setSelectedSpecies(Species selectedSpecies) {
        this.selectedSpecies = selectedSpecies;
    }

    public LiveData<Location> getLocation() {
        return locationMutableLiveData;
    }

    public void setLocationMutableLiveData(Location location) {
        locationMutableLiveData.setValue(location);
    }

    public LiveData<StoredFishCatch> getAllFishCatchResponseLiveData() {
        return allFishCatchResponseMutableLiveData;
    }

    public int getTourId() {
        return tourId;
    }

    public LiveData<StoredToss> getStoredToss(String tossId){
        return this.mRepository.getStoredToss(tossId);
    }

    public StoredToss getStoredToss(int tossID) {
        return this.mRepository.getSelectedToss(tossID);
    }

    public LiveData<Boolean> pullHaveCatchesRegistered(String pullId) {
        MutableLiveData<Boolean> result = new MutableLiveData<Boolean>();

        mRepository.getStoredAnimalCatchCountByPullId(pullId).observe(this.mView, count -> {
            if ( count > 0 ) {
                result.postValue(true);
            } else {
                mRepository.getStoredFishCatchCountByPullId(pullId).observe(this.mView, fishCount -> {
                    if (fishCount > 0 ){
                        result.postValue(true);
                    } else {
                        result.postValue(false);
                    }
                });
            }
        });

        return result;
    }

}
