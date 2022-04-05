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

package is.stokkur.afladagbok.android.start.equipment;

import android.app.Activity;
import androidx.lifecycle.ViewModelProviders;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.start.StartTourActivity;
import is.stokkur.afladagbok.android.start.StartTourViewModel;
import is.stokkur.afladagbok.android.start.harbor.SelectHarborFragment;
import is.stokkur.afladagbok.android.utils.Utils;
import is.stokkur.afladagbok.android.widget.TextWatcherAdapter;

import static is.stokkur.afladagbok.android.start.equipment.StartUtils.setupInputLayout;
import static is.stokkur.afladagbok.android.start.equipment.StartUtils.throwIfZeroOrLess;

/**
 * Created by annalaufey on 1/11/18.
 */

public class FishingHandFragment
        extends BaseFragment {

    private EditText lineInput;
    private Button nextStepButton;
    private StartTourViewModel viewModel;
    private EditText focusThief;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fishing_hand_fragment, container, false);
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        ((StartTourActivity) getActivity()).changeHeaderTitle(getString(R.string.type_of_hand));
        viewModel = ViewModelProviders.of(getActivity()).get(StartTourViewModel.class);

        Activity activity = getActivity();

        nextStepButton = view.findViewById(R.id.next_step_button);
        nextStepButton.setOnClickListener(v -> saveValueAndNext());

        focusThief = view.findViewById(R.id.edt_thief);

        TextWatcher watcher = new TextWatcherAdapter() {
            @Override
            public void afterTextChanged(Editable s) {
                toggleViews();
            }
        };

        lineInput = setupInputLayout(activity, view, R.id.hand_amount_layout,
                R.id.hand_amount_input, watcher, String.valueOf(viewModel.
                        getStartTourEquipment().getNumberOfHandEquipment()));

        lineInput.setOnEditorActionListener(this);
        getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_NOTHING);

        toggleViews();
    }

    @SuppressWarnings("ResultOfMethodCallIgnored")
    private void toggleViews() {
        try {
            throwIfZeroOrLess(lineInput);
            nextStepButton.setEnabled(true);
            nextStepButton.setAlpha(1f);
        } catch (Exception ex) {
            nextStepButton.setEnabled(false);
            nextStepButton.setAlpha(.5f);
        }
    }

    private void saveValueAndNext() {
        viewModel.getStartTourEquipment().setNumberOfHandEquipment(
                Integer.parseInt(lineInput.getText().toString().trim()));
        ((StartTourActivity) getActivity()).replaceFragmentWithAnimation(new SelectHarborFragment());
    }


    @Override
    public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
        if (actionId == EditorInfo.IME_ACTION_DONE) {
            lineInput.setFocusable(false);
            lineInput.setFocusableInTouchMode(true);
            lineInput.clearFocus();
            focusThief.requestFocus();
            Utils.hideSoftKeyboard(getActivity());
        }
        return super.onEditorAction(v, actionId, event);
    }
}
