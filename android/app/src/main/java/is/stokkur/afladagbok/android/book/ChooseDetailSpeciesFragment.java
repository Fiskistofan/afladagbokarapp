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

import android.content.Context;
import android.graphics.Rect;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.text.Editable;
import android.text.InputType;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;
import java.util.UUID;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.db.entity.StoredPull;
import is.stokkur.afladagbok.android.models.RegisterAnimalCatchBody;
import is.stokkur.afladagbok.android.models.RegisterFishCatchBody;
import is.stokkur.afladagbok.android.models.Species;
import is.stokkur.afladagbok.android.utils.CustomSwitchButton;
import is.stokkur.afladagbok.android.utils.SpeciesID;
import is.stokkur.afladagbok.android.widget.TextWatcherAdapter;

/**
 * Created by annalaufey on 11/16/17.
 */

public class ChooseDetailSpeciesFragment
        extends BaseFragment
        implements TextView.OnEditorActionListener {

    @BindView(R.id.catch_weight)
    EditText catchWeight;
    @BindView(R.id.amount_title)
    TextView amountTitle;
    @BindView(R.id.custom_button_description)
    TextView customButtonDescription;
    @BindView(R.id.is_small_fish_switch)
    CustomSwitchButton customSwitchButton;

    TextView guttedDescription;
    @BindView(R.id.is_gutted_switch)
    CustomSwitchButton guttedSwitchButton;

    @BindView(R.id.save_register_catch_button)
    Button registerBtn;

    BookViewModel viewModel;

    boolean isOpened;
    View rootView;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.choose_detail_species_fragment, container, false);
        ButterKnife.bind(this, view);
        viewModel = ViewModelProviders.of(getActivity()).get(BookViewModel.class);
        viewModel.mView = this;
        guttedDescription = view.findViewById(R.id.custom_button_gutted_description);
        guttedSwitchButton = view.findViewById(R.id.is_gutted_switch);
        initViewModel();
        guttedSwitchButton.setButtonText(getResources().getString(R.string.is_gutted_negative),getResources().getString(R.string.is_gutted_positive));
        catchWeight.setOnEditorActionListener(this);

        final View registerButton = view.findViewById(R.id.save_register_catch_button);
        catchWeight.addTextChangedListener(new TextWatcherAdapter() {
            @Override
            public void afterTextChanged(Editable s) {
                try {
                    if (Double.parseDouble(catchWeight.getText().toString().trim()) <= 0) {
                        throw new Exception();
                    }
                    registerButton.setEnabled(true);
                    registerButton.setAlpha(1f);
                } catch (Exception ex) {
                    registerButton.setEnabled(false);
                    registerButton.setAlpha(.5f);
                }
            }
        });
        catchWeight.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean b) {
                if(b){
                    registerBtn.setText(R.string.register_catch_weight_ok);
                } else {
                    registerBtn.setText(R.string.register_catch_continue);
                }
            }
        });
        rootView = view;
        view.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                Rect r = new Rect();
                rootView.getWindowVisibleDisplayFrame(r);
                int screenHeight = rootView.getRootView().getHeight();
                int keypadHeight = screenHeight - r.bottom;
                if (keypadHeight > screenHeight * 0.15) {
                    // keyboard opening
                } else {
                    // Keyboard closing.
                    catchWeight.clearFocus();

                }
            }
        });
        catchWeight.setText(null);
        return view;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        Species species = viewModel.getSelectedSpecies();
        if (species != null) {
            SelectSpecies(species);
        }
    }

    public void SelectSpecies(Species species) {
        viewModel.setSelectedSpecies(species);
        int speciesId = viewModel.getSpeciesId();
        updateSpeciesDetails(speciesId, species.getSpeciesName());

        if (speciesId == SpeciesID.FISH) {
            customSwitchButton.setVisibility(View.VISIBLE);
            customButtonDescription.setVisibility(View.VISIBLE);

            if (isFishLuda(species.getId())) {
                customButtonDescription.setText(getResources().getString(R.string.landed_or_released));
                customSwitchButton.setButtonText(getResources().getString(R.string.kept), getResources().getString(R.string.released));

                guttedDescription.setVisibility(View.INVISIBLE);
                guttedSwitchButton.setVisibility(View.INVISIBLE);
            } else {
                guttedDescription.setVisibility(View.VISIBLE);
                guttedSwitchButton.setVisibility(View.VISIBLE);
            }
        }
    }

    protected void updateSpeciesDetails(int speciesId, String name) {
        View view = getView();
        if (view == null) {
            return;
        }
        view.<ImageView>findViewById(R.id.species_detail_image)
                .setImageResource(speciesId == SpeciesID.FISH ? R.drawable.ic_fish : R.drawable.ic_mammal);
        view.<TextView>findViewById(R.id.species_detail_name).setText(name);
    }

    public void initViewModel() {
        switch (viewModel.getSpeciesId()) {
            case SpeciesID.FISH:
                amountTitle.setText(getResources().getString(R.string.weight_kg));
                catchWeight.setHint(getResources().getString(R.string.insert_weight));
                catchWeight.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
                break;
            case SpeciesID.OTHER:
                amountTitle.setText(getResources().getString(R.string.amount_stk));
                catchWeight.setHint(getResources().getString(R.string.insert_amount));
                catchWeight.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_SIGNED);
                break;
        }
    }

    @OnClick(R.id.save_register_catch_button)
    public void onSaveClick() {
        if(catchWeight.isFocused()){
            catchWeight.clearFocus();
            hideSoftKeyboard();
            return;
        }
        if (catchWeight.getText().toString().isEmpty()) {
            displayError(getString(R.string.insert_weight_error), true);
            return;
        }
        switch (viewModel.getSpeciesId()) {
            case SpeciesID.FISH:
                registerCaughtFish();
                break;
            case SpeciesID.OTHER:
                registerCaughtAnimal();
                break;
            default:
                registerCaughtFish();
                break;
        }
        getActivity().finish();
    }

    protected void registerCaughtFish() {
        List<StoredPull> pulls = viewModel.getStoredPulls();
        double weight = Double.parseDouble(catchWeight.getText().toString().trim()) / pulls.size();
        for (StoredPull pull : pulls) {
            String uuid = UUID.randomUUID().toString();
            RegisterFishCatchBody registerCatchBody = generateRegisterFishCatchBody(
                    pull.getPullId(), weight);
            viewModel.registerCaughtFishInTour(viewModel.getTourId(), uuid, registerCatchBody);
            viewModel.saveCaughtFishToDatabase(getSelectedSpecies(), uuid, registerCatchBody);
        }
    }

    protected void registerCaughtAnimal() {
        List<StoredPull> pulls = viewModel.getStoredPulls();

        StoredPull pull;
        int size = pulls.size();

        final double total = Double.parseDouble(catchWeight.getText().toString().trim());
        int countLeft = (int) total;
        int averageCount = (int) Math.ceil(total / size);
        int count;

        for (int i = 0; i < size; ++i) {
            if (countLeft <= 0) {
                break;
            }
            pull = pulls.get(i);

            count = Math.min(countLeft, averageCount);

            String uuid = UUID.randomUUID().toString();
            RegisterAnimalCatchBody registerCatchBody = generateRegisterAnimalCatchBody(
                    pull.getPullId(), count);
            viewModel.registerCaughtAnimalsInTour(viewModel.getTourId(), uuid, registerCatchBody);
            viewModel.saveCaughtAnimalToDatabase(getSelectedSpecies(), uuid, registerCatchBody);

            countLeft -= averageCount;
        }
    }

    private void hideSoftKeyboard()
    {
        InputMethodManager imm = (InputMethodManager)this.getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(this.getView().getApplicationWindowToken(), 0);
    }

    private RegisterFishCatchBody generateRegisterFishCatchBody(String pullId, double weight) {
        RegisterFishCatchBody registerCatchBody = new RegisterFishCatchBody();
        registerCatchBody.setFishSpeciesId(viewModel.getSelectedSpecies().getId());
        registerCatchBody.setLatitude(((BookCatchActivity) getActivity()).getLastKnownLocation().getLatitude());
        registerCatchBody.setLongitude(((BookCatchActivity) getActivity()).getLastKnownLocation().getLongitude());
        registerCatchBody.setPullId(pullId);
        registerCatchBody.setWeight(weight);
        if (isFishLuda(viewModel.getSelectedSpecies().getId())) {
            registerCatchBody.setReleased(customSwitchButton.isPositive());
        } else {
            registerCatchBody.setSmallFish(customSwitchButton.isPositive());
            registerCatchBody.setGutted(guttedSwitchButton.isPositive());
        }
        return registerCatchBody;
    }

    private RegisterAnimalCatchBody generateRegisterAnimalCatchBody(String pullId, int count) {
        RegisterAnimalCatchBody registerCatchBody = new RegisterAnimalCatchBody();
        registerCatchBody.setOtherSpeciesId(viewModel.getSelectedSpecies().getId());
        registerCatchBody.setLatitude(((BookCatchActivity) getActivity()).getLastKnownLocation().getLatitude());
        registerCatchBody.setLongitude(((BookCatchActivity) getActivity()).getLastKnownLocation().getLongitude());
        registerCatchBody.setPullId(pullId);
        registerCatchBody.setCount(count);
        return registerCatchBody;
    }

    protected Species getSelectedSpecies() {
        return viewModel.getSelectedSpecies();
    }

    @Override
    public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
        switch (v.getId()) {
            case R.id.catch_weight:
                break;
        }
        return false;
    }

    protected boolean isFishLuda(int speciesId) {
        return (speciesId == SpeciesID.LUDA || speciesId == SpeciesID.LUDA_2 || speciesId == SpeciesID.LUDA_3);
    }

}
