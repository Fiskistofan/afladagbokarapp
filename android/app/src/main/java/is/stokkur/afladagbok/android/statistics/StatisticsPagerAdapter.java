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

package is.stokkur.afladagbok.android.statistics;

import android.content.Context;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;
import android.util.Log;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.statistics.lastTrip.LastTripStatisticsFragment;
import is.stokkur.afladagbok.android.statistics.pastTours.PastStatisticChildFragment;
import is.stokkur.afladagbok.android.statistics.pastTours.PastStatisticsFragment;
import is.stokkur.afladagbok.android.statistics.timePeriod.TimePeriodStatisticChildFragment;
import is.stokkur.afladagbok.android.statistics.timePeriod.TimePeriodStatisticsFragment;


/**
 * Created by annalaufey on 11/22/17.
 */

public class StatisticsPagerAdapter extends FragmentPagerAdapter {

    private static final int LAST_TRIP_POSITION = 0;
    private static final int PAST_TRIP_POSITION = 1;
    private static final int TIME_PERIOD_POSITION = 2;
    private static final int NUM_OF_ITEMS = 3; // No of ViewPager items
    private final FragmentManager mFragmentManager;
    private BaseFragment mFragmentAtPos1; // Fragment at index 1
    private BaseFragment mFragmentAtPos2; // Fragment at index 2
    private Context context;

    public StatisticsPagerAdapter(FragmentManager fragmentManager, Context context) {
        super(fragmentManager);
        this.mFragmentManager = fragmentManager;
        this.context = context;
    }

    @Override
    public Fragment getItem(int position) {
        if (position == PAST_TRIP_POSITION) {
            if (mFragmentAtPos1 == null) {

                mFragmentAtPos1 = PastStatisticsFragment.newInstance(new PageFragmentListener() {
                    @Override
                    public void onSwitchToNextFragment(int id) {
                        Log.d("tourid", "id : " + id);
                        mFragmentManager.beginTransaction().remove(mFragmentAtPos1).commitNow();
                        mFragmentAtPos1 = PastStatisticChildFragment.newInstance();
                        mFragmentAtPos1.setShowingChild(true);
                        mFragmentAtPos1.setChildSelectedId(id);
                        notifyDataSetChanged();
                    }

                    @Override
                    public void onSwitchToNextFragment(String dateFrom, String dateTo) {

                    }
                });
            }
            return mFragmentAtPos1;
        }
        if (position == TIME_PERIOD_POSITION) {
            if (mFragmentAtPos2 == null) {
                mFragmentAtPos2 = TimePeriodStatisticsFragment.newInstance(new PageFragmentListener() {
                    @Override
                    public void onSwitchToNextFragment(int id) {
                    }

                    @Override
                    public void onSwitchToNextFragment(String dateFrom, String dateTo) {
                        mFragmentManager.beginTransaction().remove(mFragmentAtPos2).commitNow();
                        mFragmentAtPos2 = TimePeriodStatisticChildFragment.newInstance(dateFrom, dateTo);
                        mFragmentAtPos2.setShowingChild(true);
                        notifyDataSetChanged();
                    }
                });
            }
            return mFragmentAtPos2;
        }
        return LastTripStatisticsFragment.newInstance();

    }

    @Override
    public int getCount() {
        return NUM_OF_ITEMS;
    }

    @Override
    public int getItemPosition(Object object) {
        if (object instanceof PastStatisticsFragment && mFragmentAtPos1 instanceof PastStatisticChildFragment) {
            return POSITION_NONE;
        } else if (object instanceof TimePeriodStatisticsFragment && mFragmentAtPos2 instanceof TimePeriodStatisticChildFragment) {
            return POSITION_NONE;
        } else if (object instanceof TimePeriodStatisticChildFragment) {
            return POSITION_NONE;
        } else if (object instanceof PastStatisticChildFragment) {
            return POSITION_NONE;
        } else if (object instanceof LastTripStatisticsFragment) {
            return POSITION_NONE;
        }
        return POSITION_UNCHANGED;
    }

    @Override
    public CharSequence getPageTitle(int position) {
        switch (position) {
            case 0:
                return context.getString(R.string.last_trip_statistics);
            case 1:
                return context.getString(R.string.past_statistics);
            case 2:
                return context.getString(R.string.time_period_statistics);
        }
        return null;
    }


    public void replaceChildFragment(BaseFragment oldFrg, int position) {
        switch (position) {
            case 1:
                mFragmentManager.beginTransaction().remove(oldFrg).commitNow();
                mFragmentAtPos1 = PastStatisticsFragment.newInstance(new PageFragmentListener() {
                    @Override
                    public void onSwitchToNextFragment(int id) {
                        mFragmentManager.beginTransaction().remove(mFragmentAtPos1).commitNow();
                        mFragmentAtPos1 = PastStatisticChildFragment.newInstance();
                        mFragmentAtPos1.setShowingChild(true);
                        mFragmentAtPos1.setChildSelectedId(id);
                        notifyDataSetChanged();
                    }

                    @Override
                    public void onSwitchToNextFragment(String dateFrom, String dateTo) {

                    }
                });
                notifyDataSetChanged();
                break;

            case 2:
                mFragmentManager.beginTransaction().remove(oldFrg).commitNow();
                mFragmentAtPos2 = TimePeriodStatisticsFragment.newInstance(new PageFragmentListener() {
                    @Override
                    public void onSwitchToNextFragment(int id) {
                        mFragmentManager.beginTransaction().remove(mFragmentAtPos2).commitNow();
                        String dateFrom;
                        String dateTo;
                        if (mFragmentAtPos2 instanceof TimePeriodStatisticsFragment) {
                            dateFrom = ((TimePeriodStatisticsFragment) mFragmentAtPos2).dateFromSelected;
                            dateTo = ((TimePeriodStatisticsFragment) mFragmentAtPos2).dateToSelected;
                        } else {
                            SimpleDateFormat dateFormat =
                                    new SimpleDateFormat("yyyy-MM-dd", new Locale("is"));
                            dateFrom = dateFormat.format(new Date());
                            dateTo = dateFormat.format(new Date());
                        }
                        mFragmentAtPos2 = TimePeriodStatisticChildFragment.newInstance(dateFrom, dateTo);
                        mFragmentAtPos2.setShowingChild(true);
                        mFragmentAtPos1.setChildSelectedId(id);
                        notifyDataSetChanged();
                    }

                    @Override
                    public void onSwitchToNextFragment(String dateFrom, String dateTo) {
                        mFragmentManager.beginTransaction().remove(mFragmentAtPos2).commitNow();
                        mFragmentAtPos2 = TimePeriodStatisticChildFragment.newInstance(dateFrom, dateTo);
                        mFragmentAtPos2.setShowingChild(true);
                        notifyDataSetChanged();
                    }
                });
                notifyDataSetChanged();
                break;

            default:
                break;
        }
    }

}
