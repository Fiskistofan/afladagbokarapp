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

import java.util.List;

import is.stokkur.afladagbok.android.db.entity.SoredPullWithCatchInfo;
import is.stokkur.afladagbok.android.db.entity.StoredPull;

/**
 * Created by annalaufey on 2/6/18.
 */
@Dao
public interface StoredPullDao {

    @Query("SELECT * FROM storedPull")
    LiveData<List<StoredPull>> loadAllStoredPull();

    @Query("SELECT * FROM storedPull WHERE sent =:sent")
    List<StoredPull> loadAllStoredUnsavedPull(boolean sent);

    @Query("select sp.*, sfc.weight, sfc.registryDate " +
            "from storedPull as sp " +
            "left join (select sfc.catchId, sfc.pullId, sfc.weight, max(sfc.registryDate) as registryDate from storedFishCatch as sfc group by sfc.pullId) as sfc " +
            "on sp.pullId = sfc.pullId " +
            "where sp.tourId = :tourId " +
            "order by sp.dateTime asc")
    LiveData<List<SoredPullWithCatchInfo>> loadAllStoredPullForTour(int tourId);

    @Insert
    void insert(StoredPull storedPulls);

    @Query("select * from StoredPull where id = :id")
    LiveData<StoredPull> loadStoredPull(int id);

    @Query("select * from StoredPull where tossId = :tossId")
    List<StoredPull> loadStoredPullForToss(String tossId);

    @Query("UPDATE StoredPull set sent =:sent WHERE pullId = :pullId")
    void markAsSent(boolean sent, String pullId);

    @Query("DELETE FROM StoredPull")
    void nukeTable();

}
