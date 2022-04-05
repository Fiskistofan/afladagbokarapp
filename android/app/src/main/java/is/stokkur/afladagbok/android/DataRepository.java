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

package is.stokkur.afladagbok.android;

import androidx.lifecycle.LiveData;

import java.util.List;

import is.stokkur.afladagbok.android.db.AppDatabase;
import is.stokkur.afladagbok.android.db.entity.SoredPullWithCatchInfo;
import is.stokkur.afladagbok.android.db.entity.StoredAnimalCatch;
import is.stokkur.afladagbok.android.db.entity.StoredFishCatch;
import is.stokkur.afladagbok.android.db.entity.StoredPull;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.db.entity.TripLocation;

/**
 * Created by annalaufey on 1/31/18.
 */

public class DataRepository {

    private static DataRepository sInstance;

    private final AppDatabase mDatabase;

    private DataRepository(final AppDatabase database) {
        mDatabase = database;
    }

    public static DataRepository getInstance(final AppDatabase database) {
        if (sInstance == null) {
            synchronized (DataRepository.class) {
                if (sInstance == null) {
                    sInstance = new DataRepository(database);
                }
            }
        }
        return sInstance;
    }

    /**
     * Get the list of products from the database and get notified when the data changes.
     */
    public LiveData<List<StoredToss>> getStoredToss() {
        return mDatabase.storedTossDao().loadAllStoredToss();
    }

    public LiveData<List<StoredPull>> getStoredPull() {
        return mDatabase.storedPullDao().loadAllStoredPull();
    }

    public LiveData<Integer> getStoredAnimalCatchCountByPullId(String pullId) {
        return mDatabase.storedCatchDao().getStoredAnimalCountByPullId(pullId);
    }

    public LiveData<Integer> getStoredFishCatchCountByPullId(String pullId) {
        return mDatabase.storedCatchDao().getStoredFishCountByPullId(pullId);
    }

    public LiveData<StoredToss> getStoredToss(String tossId) {
        return mDatabase.storedTossDao().getStoredToss(tossId);
    }

    public List<StoredPull> getStoredUnsavedPull() {
        return mDatabase.storedPullDao().loadAllStoredUnsavedPull(false);
    }

    public List<StoredToss> getStoredUnsavedToss() {
        return mDatabase.storedTossDao().loadAllStoredUnsavedToss(false);
    }

    public List<StoredFishCatch> getStoredUnsavedFishCatch() {
        return mDatabase.storedCatchDao().loadAllStoredUnsavedFishCatch(false);
    }

    public List<StoredAnimalCatch> getStoredUnsavedAnimalCatch() {
        return mDatabase.storedCatchDao().loadAllStoredUnsavedAnimalCatch(false);
    }

    public void saveStoredToss(StoredToss storedToss) {
        mDatabase.saveTossData(storedToss);
    }

    public void saveStoredPull(StoredPull storedPull) {
        mDatabase.savePullData(storedPull);
    }

    public LiveData<List<SoredPullWithCatchInfo>> getAllSavedPulls(int tourId) {
        return mDatabase.storedPullDao().loadAllStoredPullForTour(tourId);
    }

    public StoredToss getSelectedToss(int id) {
        return mDatabase.storedTossDao().loadStoredToss(id);
    }

    public void saveStoredFishCatch(StoredFishCatch storedFishCatch) {
        mDatabase.saveFishCatchData(storedFishCatch);
    }

    public void saveStoredAnimalCatch(StoredAnimalCatch storedAnimalCatch) {
        mDatabase.saveAnimalCatchData(storedAnimalCatch);
    }

    public void updateStoredFishCatch(StoredFishCatch storedFishCatch) {
        mDatabase.updateFishCatchData(storedFishCatch);
    }

    public void updateStoredAnimalCatch(StoredAnimalCatch storedAnimalCatch) {
        mDatabase.updateAnimalCatchData(storedAnimalCatch);
    }

    public LiveData<List<StoredFishCatch>> getAllStoredFishCatch(int tourId) {
        return mDatabase.storedCatchDao().loadAllStoredFishCatchForTour(tourId);
    }

    public LiveData<List<StoredAnimalCatch>> getAllStoredAnimalCatch(int tourId) {
        return mDatabase.storedCatchDao().loadAllStoredAnimalCatchForTour(tourId);
    }

    public LiveData<StoredFishCatch> getStoredFishCatch(String catchId) {
        return mDatabase.storedCatchDao().getStoredFishById(catchId);
    }

    public LiveData<StoredAnimalCatch> getStoredAnimalCatch(String catchId) {
        return mDatabase.storedCatchDao().getStoredAnimalById(catchId);
    }

    public void markTossAsStored(String tossId) {
        mDatabase.markTossAsStored(tossId);
    }

    public void setPulledCountInToss(int pulledCount, String tossId) {
        mDatabase.updatePullCount(tossId, pulledCount);
    }

    public void markPullAsStored(String pullId) {
        mDatabase.markPullAsStored(pullId);
    }

    public void markFishCatchAsStored(String catchId) {
        mDatabase.markFishCatchAsStored(catchId);
    }

    public void markAnimalCatchAsStored(String catchId) {
        mDatabase.markAnimalCatchAsStored(catchId);
    }

    public void deleteAllData() {
        mDatabase.nukeAllTables();
    }

    public void saveTripRouteLocation(TripLocation location) {
        mDatabase.storeTripRouteLocation(location);
    }

    public LiveData<List<TripLocation>> getTripRoute() {
        return mDatabase.tripRouteDao().getTripRoute();
    }

}
