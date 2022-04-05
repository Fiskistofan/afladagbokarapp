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
import android.os.Bundle;
import androidx.annotation.Nullable;
import com.google.android.material.tabs.TabLayout;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseActivity;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.base.BaseTabFragment;
import is.stokkur.afladagbok.android.base.OnBackPressedListener;

/**
 * Created by annalaufey on 11/10/17.
 */

public class StatisticsFragment extends BaseTabFragment implements OnBackPressedListener {

    @BindView(R.id.view_pager_container)
    ViewPager viewPager;
    @BindView(R.id.tab_layout)
    TabLayout tabLayout;
    private StatisticsPagerAdapter statisticsPagerAdapter;
    private ViewPager.OnPageChangeListener listener;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.statistics_fragment, container, false);
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        setupAdapter();
        tabLayout.setupWithViewPager(viewPager, true);
        ((BaseActivity) getActivity()).setOnBackPressedListener(this);
    }

    protected void setupAdapter() {
        statisticsPagerAdapter = new StatisticsPagerAdapter(getChildFragmentManager(), getActivity());
        viewPager.setAdapter(statisticsPagerAdapter);
    }

    @Override
    public void onResume() {
        super.onResume();
        tabLayout.addOnTabSelectedListener(this);
        if (listener != null) {
            viewPager.addOnPageChangeListener(listener);
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        tabLayout.removeOnTabSelectedListener(this);
        if (listener != null) {
            viewPager.removeOnPageChangeListener(listener);
        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof ViewPager.OnPageChangeListener) {
            listener = (ViewPager.OnPageChangeListener) context;
        }
    }

    @Override
    public boolean goBack() {
        Fragment fragment = statisticsPagerAdapter.getItem(viewPager.getCurrentItem());
        // could be null if not instantiated yet
        if (fragment != null && fragment instanceof BaseFragment) {
            if (fragment.getView() != null) {
                BaseFragment bf = (BaseFragment) fragment;
                if (bf.isShowingChild()) {
                    replaceChild(bf, viewPager.getCurrentItem());
                    return true;
                }
            }
        }
        return false;
    }

    public void replaceChild(BaseFragment oldFrg, int position) {
        statisticsPagerAdapter.replaceChildFragment(oldFrg, position);
    }

}
