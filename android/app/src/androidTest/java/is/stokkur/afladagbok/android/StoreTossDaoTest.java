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

import androidx.room.Room;
import androidx.test.platform.app.InstrumentationRegistry;
import androidx.test.ext.junit.runners.AndroidJUnit4;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import is.stokkur.afladagbok.android.db.AppDatabase;
import is.stokkur.afladagbok.android.db.dao.StoredTossDao;
import is.stokkur.afladagbok.android.db.entity.StoredToss;

import static is.stokkur.afladagbok.android.TestData.STORED_TOSS;
import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;

/**
 * Created by annalaufey on 1/31/18.
 */
@RunWith(AndroidJUnit4.class)
public class StoreTossDaoTest {


    private AppDatabase mDatabase;

    private StoredTossDao mStoredTossDao;

    @Before
    public void initDb() throws Exception {
        // using an in-memory database because the information stored here disappears when the
        // process is killed
        mDatabase = Room.inMemoryDatabaseBuilder(InstrumentationRegistry.getContext(),
                AppDatabase.class)
                // allowing main thread queries, just for testing
                .allowMainThreadQueries()
                .build();

        mStoredTossDao = mDatabase.storedTossDao();
    }

    @After
    public void closeDb() throws Exception {
        mDatabase.close();
    }


    @Test
    public void storeTossAndReadInList() throws Exception {
        STORED_TOSS.setId(1);
        mStoredTossDao.insert(STORED_TOSS);

        StoredToss toss = mStoredTossDao.loadStoredToss(STORED_TOSS.getId());

        assertThat(toss.getId(), is(STORED_TOSS.getId()));
        assertThat(toss.getTourId(), is(STORED_TOSS.getTourId()));
        assertThat(toss.getCount(), is(STORED_TOSS.getCount()));
        assertThat(toss.getDateTime(), is(STORED_TOSS.getDateTime()));
        assertThat(toss.getLatitude(), is(STORED_TOSS.getLatitude()));
        assertThat(toss.getLongitude(), is(STORED_TOSS.getLongitude()));
        assertThat(toss.getTossId(), is(STORED_TOSS.getTossId()));

    }


}
