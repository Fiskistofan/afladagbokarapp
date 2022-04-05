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

import java.util.List;

import is.stokkur.afladagbok.android.db.AppDatabase;
import is.stokkur.afladagbok.android.db.dao.StoredPullDao;
import is.stokkur.afladagbok.android.db.entity.StoredPull;

import static is.stokkur.afladagbok.android.TestData.STORED_PULL;
import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;

/**
 * Created by annalaufey on 2/6/18.
 */

@RunWith(AndroidJUnit4.class)
public class StorePullDaoTest {

    private AppDatabase mDatabase;

    private StoredPullDao mStoredPullDao;

    @Before
    public void initDb() throws Exception {
        // using an in-memory database because the information stored here disappears when the
        // process is killed
        mDatabase = Room.inMemoryDatabaseBuilder(InstrumentationRegistry.getContext(),
                AppDatabase.class)
                // allowing main thread queries, just for testing
                .allowMainThreadQueries()
                .build();

        mStoredPullDao = mDatabase.storedPullDao();
    }

    @After
    public void closeDb() throws Exception {
        mDatabase.close();
    }


    @Test
    public void storePullAndReadInList() throws Exception {

        mStoredPullDao.insert(STORED_PULL);
        List<StoredPull> pulls = LiveDataTestUtil.getValue(mStoredPullDao.loadAllStoredPull());

        assertThat(pulls.size(), is(1));

    }

}
