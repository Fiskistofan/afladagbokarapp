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

package is.stokkur.afladagbok.android.base;

import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import is.stokkur.afladagbok.android.book.NextFragmentListener;
import is.stokkur.afladagbok.android.db.entity.StoredPull;
import is.stokkur.afladagbok.android.statistics.PageFragmentListener;

/**
 * Created by annalaufey on 11/10/17.
 */

public class BaseFragment extends Fragment implements NextFragmentListener, TextView.OnEditorActionListener {
    protected PageFragmentListener pageFragmentListener;
    private boolean mShowingChild;
    private int childSelectedId;
    private String childSelectedDateFrom;
    private String childSelectedDateTo;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void goToNextFragment() {

    }

    @Override
    public void goToNextFragment(int id) {

    }

    @Override
    public void goToNextFragment(StoredPull storedPull) {

    }

    public boolean isShowingChild() {
        return mShowingChild;
    }

    public void setShowingChild(boolean showingChild) {
        mShowingChild = showingChild;
    }

    public int getChildSelectedId() {
        return childSelectedId;
    }

    public void setChildSelectedId(int id) {
        childSelectedId = id;
    }

    public void setChildSelectedDates(String dateFrom, String dateTo) {
        childSelectedDateFrom = dateFrom;
        childSelectedDateTo = dateTo;
    }

    public void displayError(String message, boolean isError) {
        BaseActivity activity = (BaseActivity) getActivity();
        activity.displayError(message, isError);
    }

    public String getChildSelectedDateFrom() {
        return childSelectedDateFrom;
    }

    public String getChildSelectedDateTo() {
        return childSelectedDateTo;
    }

    public void showProgressBar() {

    }

    public void hideProgressBar() {

    }

    @Override
    public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
        return false;
    }
}
