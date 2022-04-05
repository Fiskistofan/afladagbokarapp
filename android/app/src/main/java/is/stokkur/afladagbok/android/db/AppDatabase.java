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

package is.stokkur.afladagbok.android.db;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;
import android.content.Context;
import androidx.annotation.VisibleForTesting;

import is.stokkur.afladagbok.android.db.dao.StoredCatchDao;
import is.stokkur.afladagbok.android.db.dao.StoredPullDao;
import is.stokkur.afladagbok.android.db.dao.StoredTossDao;
import is.stokkur.afladagbok.android.db.dao.TripRouteDao;
import is.stokkur.afladagbok.android.db.entity.StoredAnimalCatch;
import is.stokkur.afladagbok.android.db.entity.StoredFishCatch;
import is.stokkur.afladagbok.android.db.entity.StoredPull;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.db.entity.TripLocation;
import is.stokkur.afladagbok.android.utils.AppExecutors;

/**
 * Created by annalaufey on 1/31/18.
 */

@Database(
        entities = {
                StoredToss.class,
                StoredPull.class,
                StoredFishCatch.class,
                StoredAnimalCatch.class,
                TripLocation.class},
        version = 1 // TODO: with new db changes don't forget to increment this for prod
)
public abstract class AppDatabase extends RoomDatabase {

    @VisibleForTesting
    public static final String DATABASE_NAME = "afladagbokin-database";
    private static AppDatabase sInstance;

    private AppExecutors mExecutors;

    public static AppDatabase getInstance(final Context context,
                                          final AppExecutors executors) {
        if (sInstance == null) {
            synchronized (AppDatabase.class) {
                if (sInstance == null) {
                    sInstance = Room.databaseBuilder(context, AppDatabase.class, DATABASE_NAME)
                            .fallbackToDestructiveMigration()
                            .build();
                    sInstance.mExecutors = executors;
                }
            }
        }
        return sInstance;
    }


    public abstract StoredTossDao storedTossDao();

    public abstract StoredPullDao storedPullDao();

    public abstract StoredCatchDao storedCatchDao();

    public abstract TripRouteDao tripRouteDao();

    private void execute(final Runnable runnable) {
        mExecutors.diskIO().execute(() -> runInTransaction(runnable));
    }

    public void saveTossData(StoredToss storedToss) {
        execute(() -> storedTossDao().insert(storedToss));
    }

    public void savePullData(StoredPull storedPull) {
        execute(() -> storedPullDao().insert(storedPull));
    }

    public void saveFishCatchData(StoredFishCatch fishCatch) {
        execute(() -> storedCatchDao().insertFishCatch(fishCatch));
    }

    public void saveAnimalCatchData(StoredAnimalCatch animalCatch) {
        execute(() -> storedCatchDao().insertAnimalCatch(animalCatch));
    }

    public void updateFishCatchData(StoredFishCatch fishCatch) {
        execute(() -> storedCatchDao().updateStoredFishCatch(fishCatch));
    }

    public void updateAnimalCatchData(StoredAnimalCatch animalCatch) {
        execute(() -> storedCatchDao().updateStoredAnimalCatch(animalCatch));
    }

    public void markTossAsStored(String tossId) {
        execute(() -> storedTossDao().markAsSent(true, tossId));
    }

    public void markPullAsStored(String pullId) {
        execute(() -> storedPullDao().markAsSent(true, pullId));
    }

    public void markFishCatchAsStored(String catchId) {
        execute(() -> storedCatchDao().markFishCatchAsSent(true, catchId));
    }

    public void markAnimalCatchAsStored(String catchId) {
        execute(() -> storedCatchDao().markAnimalCatchAsSent(true, catchId));
    }

    public void updatePullCount(String tossId, int pulledCount) {
        execute(() -> {
            int storedTossPullCount = storedTossDao().getPulledCountFromToss(tossId);
            storedTossDao().updatePulledCount(pulledCount + storedTossPullCount, tossId);
        });
    }

    public void nukeAllTables() {
        execute(() -> {
            storedPullDao().nukeTable();
            storedTossDao().nukeTable();
            storedCatchDao().nukeFishTable();
            storedCatchDao().nukeAnimalTable();
            tripRouteDao().emptyTable();
        });
    }

    public void storeTripRouteLocation(TripLocation location) {
        execute(() -> tripRouteDao().insertLocation(location));
    }

}
