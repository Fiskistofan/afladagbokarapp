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

import android.app.Application;
import android.content.Context;

import com.firebase.jobdispatcher.Constraint;
import com.firebase.jobdispatcher.FirebaseJobDispatcher;
import com.firebase.jobdispatcher.GooglePlayDriver;
import com.firebase.jobdispatcher.Job;
import com.firebase.jobdispatcher.Lifetime;
import com.firebase.jobdispatcher.Trigger;

import java.util.Locale;

import is.stokkur.afladagbok.android.db.AppDatabase;
import is.stokkur.afladagbok.android.services.SyncJobService;
import is.stokkur.afladagbok.android.utils.AppExecutors;
import is.stokkur.afladagbok.android.utils.Keys;
import is.stokkur.afladagbok.android.utils.Persistence;


import io.github.inflationx.calligraphy3.*;
import io.github.inflationx.viewpump.ViewPump;



/**
 * Created by annalaufey on 10/24/17.
 */

public class AfladagbokApplication extends Application {

    private static AfladagbokApplication instance;
    FirebaseJobDispatcher dispatcher;
    Job myJob;
    private AppExecutors mAppExecutors;

    public static synchronized AfladagbokApplication getInstance() {
        return instance;
    }

    /**
     * Get the application context from anywhere in the app
     *
     * @return the application context
     */
    public static Context getAppContext() {
        return instance.getApplicationContext();
    }

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
        Persistence.init(this);
        mAppExecutors = new AppExecutors();
        dispatcher = new FirebaseJobDispatcher(new GooglePlayDriver(getAppContext()));
        Locale.setDefault(new Locale("is"));


        ViewPump.init(ViewPump.builder()
        .addInterceptor(new CalligraphyInterceptor(
                new CalligraphyConfig.Builder()
                        .setDefaultFontPath("fonts/Roboto-Regular.OTF")
                        .setFontAttrId(R.attr.fontPath)
                        .build()))
        .build());


        myJob = dispatcher.newJobBuilder()
                .setService(SyncJobService.class) // the JobService that will be called
                .setTag(Keys.SYNC_JOB_KEY)// uniquely identifies the job
                .setConstraints(Constraint.ON_ANY_NETWORK)
                .setLifetime(Lifetime.UNTIL_NEXT_BOOT)
                .setRecurring(true)
                .setTrigger(Trigger.executionWindow(0, 5))
                .build();
    }

    public AppDatabase getDatabase() {
        return AppDatabase.getInstance(this, mAppExecutors);
    }

    public DataRepository getRepository() {
        return DataRepository.getInstance(getDatabase());
    }

    public AppExecutors getAppExecutors() {
        return mAppExecutors;
    }

    public void startSyncJob() {
        dispatcher.mustSchedule(myJob);
    }

    public void cancelSyncJob() {
        dispatcher.cancel(Keys.SYNC_JOB_KEY);
    }

}
