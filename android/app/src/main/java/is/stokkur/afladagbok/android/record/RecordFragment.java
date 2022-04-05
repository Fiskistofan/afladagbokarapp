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

package is.stokkur.afladagbok.android.record;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;

import androidx.annotation.Nullable;
import androidx.lifecycle.ViewModelProviders;

import java.util.ArrayList;
import java.util.List;

import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.ActionListener;
import is.stokkur.afladagbok.android.MainActivity;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.book.BookCatchActivity;
import is.stokkur.afladagbok.android.db.entity.StoredToss;

public class RecordFragment extends BaseFragment implements ActionListener {
    RecordViewModel viewModel;
    private List<StoredToss> storedTossArrayList;

    private ProgressBar mEndTourProgressBar;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater,
                             @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.record_fragment, container, false);
        ButterKnife.bind(this, view);
        viewModel = ViewModelProviders.of(this).get(RecordViewModel.class);
        viewModel.mView = this;
        viewModel.getError().observe(this, errorWrapper -> {
            if (errorWrapper != null && errorWrapper.getThrowable() != null) {
                showError(errorWrapper.getThrowable().getMessage(), true);
            } else {
                showError(getResources().getString(R.string.general_error), true);
            }
        });
        storedTossArrayList = new ArrayList<>();

        return view;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        mEndTourProgressBar = view.findViewById(R.id.end_tour_progress);
        mEndTourProgressBar.setVisibility(View.INVISIBLE);

    }

    @SuppressLint("CheckResult")
    @Override
    public void onResume() {
        super.onResume();
        ((MainActivity) getActivity()).setActionListener(this);
    }

    @Override
    public void onPause() {
        super.onPause();
    }

    public void showError(String error, boolean isError) {
        getActivity().runOnUiThread(() -> displayError(error, isError));
    }

    @Override
    public void displayError(String message, boolean isError) {
        super.displayError(message, isError);
        mEndTourProgressBar.setVisibility(View.INVISIBLE);
    }

    @Override
    public void onActionClicked(View view) {
        Intent intent = new Intent(getActivity(), BookCatchActivity.class);
        startActivity(intent);
    }

}
