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

package is.stokkur.afladagbok.android.db.entity;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

/**
 * Created by annalaufey on 2/8/18.
 */
@Entity(tableName = "storedFishCatch")
public class StoredFishCatch {

    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    private int id;

    @ColumnInfo(name = "tourId")
    private int tourId;

    @ColumnInfo(name = "catchId")
    private String catchId;

    @ColumnInfo(name = "fishSpeciesId")
    private int fishSpeciesId;

    @ColumnInfo(name = "speciesName")
    private String speciesName;

    @ColumnInfo(name = "registryDate")
    private String registryDate;

    @ColumnInfo(name = "edited")
    private boolean edited;

    @ColumnInfo(name = "weight")
    private double weight;

    @ColumnInfo(name = "gutted")
    private boolean gutted;

    @ColumnInfo(name = "released")
    private boolean released;

    @ColumnInfo(name = "smallFish")
    private boolean smallFish;

    @ColumnInfo(name = "latitude")
    private double latitude;

    @ColumnInfo(name = "longitude")
    private double longitude;

    @ColumnInfo(name = "pullId")
    private String pullId;

    @ColumnInfo(name = "sent")
    private boolean sent;

    public StoredFishCatch(int tourId, String catchId, int fishSpeciesId, String speciesName, String registryDate, boolean edited, double weight, boolean gutted, boolean released, boolean smallFish, double latitude, double longitude, String pullId) {
        this.tourId = tourId;
        this.catchId = catchId;
        this.fishSpeciesId = fishSpeciesId;
        this.speciesName = speciesName;
        this.registryDate = registryDate;
        this.edited = edited;
        this.weight = weight;
        this.gutted = gutted;
        this.released = released;
        this.smallFish = smallFish;
        this.latitude = latitude;
        this.longitude = longitude;
        this.pullId = pullId;
        this.sent = false;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public int getFishSpeciesId() {
        return fishSpeciesId;
    }

    public void setFishSpeciesId(int fishSpeciesId) {
        this.fishSpeciesId = fishSpeciesId;
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

    public boolean isSent() {
        return sent;
    }

    public void setSent(boolean sent) {
        this.sent = sent;
    }

}

