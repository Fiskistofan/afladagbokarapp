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

package is.stokkur.afladagbok.android.models;

import is.stokkur.afladagbok.android.db.entity.StoredAnimalCatch;
import is.stokkur.afladagbok.android.db.entity.StoredFishCatch;

/**
 * Created by annalaufey on 2/8/18.
 */

public class FishAndAnimalCatch {
    private int id;

    private int speciesType;

    private int tourId;

    private String catchId;

    private int speciesId;

    private String speciesName;

    private String registryDate;

    private boolean edited;

    private double weight;

    private boolean gutted;

    private boolean released;

    private boolean smallFish;

    private double latitude;

    private double longitude;

    private String pullId;

    public FishAndAnimalCatch(int speciesType, StoredFishCatch storedFishCatch) {
        this.id = storedFishCatch.getId();
        this.speciesType = speciesType;
        this.tourId = storedFishCatch.getTourId();
        this.catchId = storedFishCatch.getCatchId();
        this.speciesId = storedFishCatch.getFishSpeciesId();
        this.speciesName = storedFishCatch.getSpeciesName();
        this.registryDate = storedFishCatch.getRegistryDate();
        this.edited = storedFishCatch.isEdited();
        this.weight = storedFishCatch.getWeight();
        this.gutted = storedFishCatch.isGutted();
        this.released = storedFishCatch.isReleased();
        this.smallFish = storedFishCatch.isSmallFish();
        this.latitude = storedFishCatch.getLatitude();
        this.longitude = storedFishCatch.getLongitude();
        this.pullId = storedFishCatch.getPullId();
    }

    public FishAndAnimalCatch(int speciesType, StoredAnimalCatch storedAnimalCatch) {
        this.id = storedAnimalCatch.getId();
        this.speciesType = speciesType;
        this.tourId = storedAnimalCatch.getTourId();
        this.catchId = storedAnimalCatch.getCatchId();
        this.speciesId = storedAnimalCatch.getOtherSpeciesId();
        this.speciesName = storedAnimalCatch.getSpeciesName();
        this.registryDate = storedAnimalCatch.getRegistryDate();
        this.edited = storedAnimalCatch.isEdited();
        this.weight = storedAnimalCatch.getCount();
        this.latitude = storedAnimalCatch.getLatitude();
        this.longitude = storedAnimalCatch.getLongitude();
        this.pullId = storedAnimalCatch.getPullId();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSpeciesType() {
        return speciesType;
    }

    public void setSpeciesType(int speciesType) {
        this.speciesType = speciesType;
    }

    public int getTourId() {
        return tourId;
    }

    public void setTourId(int tourId) {
        this.tourId = tourId;
    }

    public String getCatchId() {
        return catchId;
    }

    public void setCatchId(String catchId) {
        this.catchId = catchId;
    }

    public int getSpeciesId() {
        return speciesId;
    }

    public void setSpeciesId(int speciesId) {
        this.speciesId = speciesId;
    }

    public String getSpeciesName() {
        return speciesName;
    }

    public void setSpeciesName(String speciesName) {
        this.speciesName = speciesName;
    }

    public String getRegistryDate() {
        return registryDate;
    }

    public void setRegistryDate(String registryDate) {
        this.registryDate = registryDate;
    }

    public boolean isEdited() {
        return edited;
    }

    public void setEdited(boolean edited) {
        this.edited = edited;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public boolean isGutted() {
        return gutted;
    }

    public void setGutted(boolean gutted) {
        this.gutted = gutted;
    }

    public boolean isReleased() {
        return released;
    }

    public void setReleased(boolean released) {
        this.released = released;
    }

    public boolean isSmallFish() {
        return smallFish;
    }

    public void setSmallFish(boolean smallFish) {
        this.smallFish = smallFish;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public String getPullId() {
        return pullId;
    }

    public void setPullId(String pullId) {
        this.pullId = pullId;
    }
}
