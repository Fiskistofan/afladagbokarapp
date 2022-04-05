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

package is.stokkur.afladagbok.android.db.dao;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

import java.util.List;

import is.stokkur.afladagbok.android.db.entity.StoredAnimalCatch;
import is.stokkur.afladagbok.android.db.entity.StoredFishCatch;

/**
 * Created by annalaufey on 2/8/18.
 */
@Dao
public interface StoredCatchDao {

    @Insert
    void insertFishCatch(StoredFishCatch storedFishCatch);

    @Insert
    void insertAnimalCatch(StoredAnimalCatch storedAnimalCatch);

    @Query("SELECT * FROM storedFishCatch WHERE tourId = :tourId")
    LiveData<List<StoredFishCatch>> loadAllStoredFishCatchForTour(int tourId);

    @Query("SELECT * FROM storedAnimalCatch WHERE tourId = :tourId")
    LiveData<List<StoredAnimalCatch>> loadAllStoredAnimalCatchForTour(int tourId);

    @Query("SELECT * FROM storedAnimalCatch WHERE catchId = :catchId ORDER BY id DESC LIMIT 1")
    LiveData<StoredAnimalCatch> getStoredAnimalById(String catchId);

    @Query("SELECT * FROM storedFishCatch WHERE catchId = :catchId ORDER BY id DESC LIMIT 1")
    LiveData<StoredFishCatch> getStoredFishById(String catchId);

    @Query("SELECT count(pullId) FROM storedAnimalCatch WHERE pullId = :pullId")
    LiveData<Integer> getStoredAnimalCountByPullId(String pullId);

    @Query("SELECT count(pullId) FROM storedFishCatch WHERE pullId = :pullId")
    LiveData<Integer> getStoredFishCountByPullId(String pullId);

    @Query("SELECT * FROM storedfishcatch WHERE sent =:sent ORDER BY id ASC")
    List<StoredFishCatch> loadAllStoredUnsavedFishCatch(boolean sent);

    @Query("SELECT * FROM storedanimalcatch WHERE sent =:sent ORDER BY id ASC")
    List<StoredAnimalCatch> loadAllStoredUnsavedAnimalCatch(boolean sent);

    @Query("UPDATE storedFishCatch SET sent =:sent WHERE catchId = :catchId")
    void markFishCatchAsSent(boolean sent, String catchId);

    @Query("UPDATE storedAnimalCatch SET sent =:sent WHERE catchId = :catchId")
    void markAnimalCatchAsSent(boolean sent, String catchId);

    @Update
    void updateStoredFishCatch(StoredFishCatch storedFishCatch);

    @Update
    void updateStoredAnimalCatch(StoredAnimalCatch storedAnimalCatch);

    @Query("DELETE FROM storedFishCatch")
    void nukeFishTable();

    @Query("DELETE FROM StoredAnimalCatch")
    void nukeAnimalTable();
}
