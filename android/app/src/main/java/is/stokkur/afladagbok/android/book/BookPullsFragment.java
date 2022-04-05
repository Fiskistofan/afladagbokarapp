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

package is.stokkur.afladagbok.android.book;

import androidx.lifecycle.ViewModelProviders;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.CheckBox;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.db.entity.SoredPullWithCatchInfo;
import is.stokkur.afladagbok.android.db.entity.StoredPull;

/**
 * Created by annalaufey on 11/16/17.
 */

public class BookPullsFragment extends BaseFragment {

    @BindView(R.id.no_pulls_layout)
    TextView noPullsLayout;

    @BindView(R.id.pulls_layout)
    ConstraintLayout pullsLayout;

    @BindView(R.id.pulls_toggle_selection)
    CheckBox toggleDragSelection;

    private TextView mActionMultiNext;

    BookViewModel viewModel;

    private TripPullsAdapter mAdapter = null;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater,
                             @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.laid_out_layout, container, false);
        ButterKnife.bind(this, view);
        viewModel = ViewModelProviders.of(getActivity()).get(BookViewModel.class);
        viewModel.mView = this;
        ((BookCatchActivity) getActivity()).setLayoutHeader(getResources().getString(R.string.back), getResources().getString(R.string.register_catch));

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity());
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        final RecyclerView recyclerView = view.findViewById(R.id.laid_out_recyclerview);
        recyclerView.setLayoutManager(linearLayoutManager);
        recyclerView.setAdapter(mAdapter = new TripPullsAdapter(getActivity(), this));

        mActionMultiNext = view.findViewById(R.id.laid_out_action_multi);
        mActionMultiNext.setOnClickListener(v -> proceedWithMultiSelection());

        mAdapter.toggleMultiSelection(true);
        toggleDragSelection.setOnCheckedChangeListener((buttonView, isChecked) -> {
            mAdapter.toggleAction();
            updateMultiButtonState();
        });
        updateMultiButtonState();

        mActionMultiNext.getViewTreeObserver().addOnGlobalLayoutListener(
                new ViewTreeObserver.OnGlobalLayoutListener() {
                    @Override
                    public void onGlobalLayout() {
                        mActionMultiNext.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                        int paddingBottom = mActionMultiNext.getMeasuredHeight();
                        ConstraintLayout.LayoutParams params = (ConstraintLayout.LayoutParams)
                                mActionMultiNext.getLayoutParams();
                        paddingBottom += params.topMargin + params.bottomMargin;
                        recyclerView.setPadding(0, 0, 0, paddingBottom);
                    }
                });

        viewModel.getAllStoredPulls().observe(this, this::initRecyclerView);

        return view;
    }

    void updateMultiButtonState() {
            int count = mAdapter.getSelectedCount();
            mActionMultiNext.setVisibility(View.VISIBLE);
            mActionMultiNext.setText(getContext().getString(R.string.continue_with_multi, count));
            if (count > 0) {
                toggleDragSelection.setText(R.string.clear_all_pulls);
                mActionMultiNext.setAlpha(1f);
                mActionMultiNext.setEnabled(true);
            } else {
                toggleDragSelection.setText(R.string.select_all_pulls);
                mActionMultiNext.setAlpha(.5f);
                mActionMultiNext.setEnabled(false);
                mActionMultiNext.setVisibility(View.INVISIBLE);
                mActionMultiNext.setEnabled(false);
            }
    }

    private void proceedWithMultiSelection() {
        proceed(mAdapter.getSelectedItems());
    }

    /**
     * Initialize the scroll view
     *
     * @param storedPulls
     */
    private void initRecyclerView(List<SoredPullWithCatchInfo> storedPulls) {
        if (storedPulls == null || storedPulls.size() == 0) {
            noPullsLayout.setVisibility(View.VISIBLE);
            pullsLayout.setVisibility(View.GONE);
            return;
        }
        pullsLayout.setVisibility(View.VISIBLE);
        noPullsLayout.setVisibility(View.GONE);
        ArrayList<CheckableStoredPull> pulls = new ArrayList<>();
        int size = storedPulls.size();
        for (int i = 0; i < size; ++i) {
            pulls.add(new CheckableStoredPull(storedPulls.get(i)));
        }
        mAdapter.replacePulls(pulls);
    }

    @Override
    public void goToNextFragment(StoredPull storedPull) {
        ArrayList<StoredPull> pulls = new ArrayList<>();
        pulls.add(storedPull);
        proceed(pulls);
    }

    private void proceed(List<StoredPull> pulls) {
        viewModel.setStoredPulls(pulls);
        ((BookCatchActivity) getActivity()).replaceFragmentWithAnimation(new ChooseSpeciesFragment());
    }

}
