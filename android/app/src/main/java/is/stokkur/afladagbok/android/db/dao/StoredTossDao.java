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

import is.stokkur.afladagbok.android.db.entity.StoredToss;


/**
 * Created by annalaufey on 1/31/18.
 */

@Dao
public interface StoredTossDao {

    @Query("SELECT id, tourId, tossId, dateTime, latitude, longitude, count, sent, pulledCount, equipmentTypeId FROM StoredToss")
    LiveData<List<StoredToss>> loadAllStoredToss();

    @Query("SELECT * FROM StoredToss WHERE sent =:sent")
    List<StoredToss> loadAllStoredUnsavedToss(boolean sent);

    @Insert
    void insert(StoredToss storedToss);

    @Query("select * from StoredToss where id = :id")
    StoredToss loadStoredToss(int id);

    @Query("select pulledCount from storedToss where tossId = :tossId")
    int getPulledCountFromToss(String tossId);

    @Query("select * from storedToss where tossId = :tossId")
    LiveData<StoredToss> getStoredToss(String tossId);

    @Query("UPDATE StoredToss set sent =:sent WHERE tossId = :tossId")
    void markAsSent(boolean sent, String tossId);

    @Query("UPDATE StoredToss set pulledCount=:pulledCount WHERE tossID =:tossId")
    void updatePulledCount(int pulledCount, String tossId);

    @Query("DELETE FROM StoredToss")
    void nukeTable();

}
