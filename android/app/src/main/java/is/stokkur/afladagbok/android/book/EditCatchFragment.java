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

import android.text.InputType;

import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.db.entity.StoredAnimalCatch;
import is.stokkur.afladagbok.android.db.entity.StoredFishCatch;
import is.stokkur.afladagbok.android.models.RegisterAnimalCatchBody;
import is.stokkur.afladagbok.android.models.RegisterFishCatchBody;
import is.stokkur.afladagbok.android.models.Species;
import is.stokkur.afladagbok.android.utils.SpeciesID;

/**
 * Created by annalaufey on 2/9/18.
 */

public class EditCatchFragment extends ChooseDetailSpeciesFragment {

    private StoredFishCatch currentStoredFish;
    private StoredAnimalCatch currentStoredAnimal;

    @Override
    public void initViewModel() {
        super.initViewModel();
        viewModel.getFishCatchById(viewModel.getEditCatchId()).observe(getActivity(), storedFishCatch -> {
            if (storedFishCatch != null) {
                viewModel.setSpeciesId(SpeciesID.FISH);
                setCurrentStoredFish(storedFishCatch);
                SelectSpecies(new Species(storedFishCatch.getFishSpeciesId(), storedFishCatch.getSpeciesName()));
                amountTitle.setText(getResources().getString(R.string.weight_kg));
                String weight = String.valueOf(storedFishCatch.getWeight());
                catchWeight.setText(weight);
                catchWeight.setSelection(weight.length());
                if (isFishLuda(storedFishCatch.getFishSpeciesId())) {
                    customSwitchButton.setButtonState(storedFishCatch.isReleased());
                } else {
                    customSwitchButton.setButtonState(storedFishCatch.isSmallFish());
                    guttedSwitchButton.setButtonState(storedFishCatch.isGutted());
                }
                catchWeight.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
            }
        });
        viewModel.getAnimalCatchById(viewModel.getEditCatchId()).observe(getActivity(), storedAnimalCatch -> {
            if (storedAnimalCatch != null) {
                viewModel.setSpeciesId(SpeciesID.OTHER);
                setCurrentStoredAnimal(storedAnimalCatch);
                SelectSpecies(new Species(storedAnimalCatch.getOtherSpeciesId(), storedAnimalCatch.getSpeciesName()));
                amountTitle.setText(getResources().getString(R.string.amount_stk));
                String count = String.valueOf(storedAnimalCatch.getCount());
                catchWeight.setText(count);
                catchWeight.setSelection(count.length());
                catchWeight.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_SIGNED);
            }
        });
    }

    private RegisterFishCatchBody generateRegisterCatchBody() {
        StoredFishCatch currentStoredFish = getCurrentStoredFish();
        RegisterFishCatchBody registerCatchBody = new RegisterFishCatchBody();
        registerCatchBody.setFishSpeciesId(currentStoredFish.getFishSpeciesId());
        registerCatchBody.setLatitude(currentStoredFish.getLatitude());
        registerCatchBody.setLongitude(currentStoredFish.getLongitude());
        registerCatchBody.setPullId(currentStoredFish.getPullId());
        registerCatchBody.setWeight(Double.parseDouble(catchWeight.getText().toString()));
        if (isFishLuda(currentStoredFish.getFishSpeciesId())) {
            registerCatchBody.setReleased(customSwitchButton.isPositive());
        } else {
            registerCatchBody.setSmallFish(customSwitchButton.isPositive());
            registerCatchBody.setGutted(guttedSwitchButton.isPositive());
        }
        return registerCatchBody;
    }

    private RegisterAnimalCatchBody generateRegisterAnimalCatchBody() {
        StoredAnimalCatch currentStoredAnimal = getCurrentStoredAnimal();
        RegisterAnimalCatchBody registerCatchBody = new RegisterAnimalCatchBody();
        registerCatchBody.setOtherSpeciesId(currentStoredAnimal.getOtherSpeciesId());
        registerCatchBody.setLatitude(currentStoredAnimal.getLatitude());
        registerCatchBody.setLongitude(currentStoredAnimal.getLongitude());
        registerCatchBody.setPullId(currentStoredAnimal.getPullId());
        registerCatchBody.setCount(Integer.parseInt(catchWeight.getText().toString()));
        return registerCatchBody;
    }

    @Override
    protected void registerCaughtFish() {
        StoredFishCatch currentStoredFish = getCurrentStoredFish();
        viewModel.registerCaughtFishInTour(currentStoredFish.getTourId(),
                currentStoredFish.getCatchId(), generateRegisterCatchBody());
        currentStoredFish.setWeight(Double.parseDouble(catchWeight.getText().toString()));
        currentStoredFish.setEdited(true);
        currentStoredFish.setSent(false);
        if (isFishLuda(currentStoredFish.getFishSpeciesId())) {
            currentStoredFish.setReleased(customSwitchButton.isPositive());
        } else {
            currentStoredFish.setSmallFish(customSwitchButton.isPositive());
            currentStoredFish.setGutted(guttedSwitchButton.isPositive());
        }
        viewModel.updateCaughtFish(currentStoredFish);
    }

    @Override
    protected void registerCaughtAnimal() {
        StoredAnimalCatch currentStoredAnimal = getCurrentStoredAnimal();
        viewModel.registerCaughtAnimalsInTour(currentStoredAnimal.getTourId(),
                currentStoredAnimal.getCatchId(), generateRegisterAnimalCatchBody());
        currentStoredAnimal.setCount(Integer.parseInt(catchWeight.getText().toString()));
        currentStoredAnimal.setEdited(true);
        currentStoredAnimal.setSent(false);
        viewModel.updateCaughtAnimal(currentStoredAnimal);
    }

    public StoredFishCatch getCurrentStoredFish() {
        return currentStoredFish;
    }

    public void setCurrentStoredFish(StoredFishCatch currentStoredFish) {
        this.currentStoredFish = currentStoredFish;
    }

    public StoredAnimalCatch getCurrentStoredAnimal() {
        return currentStoredAnimal;
    }

    public void setCurrentStoredAnimal(StoredAnimalCatch currentStoredAnimal) {
        this.currentStoredAnimal = currentStoredAnimal;
    }

}
