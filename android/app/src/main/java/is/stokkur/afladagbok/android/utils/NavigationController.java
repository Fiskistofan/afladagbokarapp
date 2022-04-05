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

package is.stokkur.afladagbok.android.utils;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import javax.inject.Inject;

import is.stokkur.afladagbok.android.MainActivity;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.begin.BeginFragment;
import is.stokkur.afladagbok.android.finish.FinishFragment;
import is.stokkur.afladagbok.android.record.RecordFragment;

/**
 * Created by annalaufey on 11/7/17.
 */

public class NavigationController {

    final private int containerId;
    final private FragmentManager fragmentManager;

    final private String START_TAG = "begin<_fragment_tag";
    final private String RECORD_TAG = "record_fragment_tag";
    final private String END_TAG = "finish_fragment_tag";

    @Inject
    public NavigationController(MainActivity mainActivity) {
        this.containerId = R.id.base_content;
        this.fragmentManager = mainActivity.getSupportFragmentManager();
    }

    public void navigateTo(State state) {
        switch (state) {
            case START:
                navigateToStart();
                break;
            case RECORD:
                navigateToRecord();
                break;
            case STOP:
                navigateToStop();
                break;
        }
    }

    private void navigateToStart() {
        removeFragmentsAndAddFragment(START_TAG, new BeginFragment(), RECORD_TAG, END_TAG);
    }

    private void navigateToRecord() {
        removeFragmentsAndAddFragment(RECORD_TAG, new RecordFragment(), START_TAG, END_TAG);
    }

    private void navigateToStop() {
        removeFragmentsAndAddFragment(END_TAG, new FinishFragment(), START_TAG, RECORD_TAG);
    }

    private void removeFragmentsAndAddFragment(String newTag,
                                               Fragment newFragment,
                                               String... tags) {
        FragmentTransaction transaction = fragmentManager.beginTransaction();
        int size = tags != null ? tags.length : 0;
        if (size > 0) {
            String tag;
            Fragment fragment;
            for (int i = 0; i < size; ++i) {
                tag = tags[i];
                fragment = fragmentManager.findFragmentByTag(tag);
                if (fragment != null) {
                    transaction.remove(fragment);
                }
            }
        }
        if (newFragment != null) {
            transaction.add(containerId, newFragment, newTag);
        }
        transaction.commitAllowingStateLoss();
    }

    public enum State {
        START, RECORD, STOP
    }

}
