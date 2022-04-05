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

/**
 * Created by annalaufey on 2/13/18.
 */

public class RegisterAnimalCatchBody {
    private int otherSpeciesId;
    private int count;
    private double latitude;
    private double longitude;
    private String pullId;

    public RegisterAnimalCatchBody() {
    }

    public RegisterAnimalCatchBody(int otherSpeciesId, int count, double latitude, double longitude, String pullId) {
        this.otherSpeciesId = otherSpeciesId;
        this.count = count;
        this.latitude = latitude;
        this.longitude = longitude;
        this.pullId = pullId;
    }

    public int getOtherSpeciesId() {
        return otherSpeciesId;
    }

    public void setOtherSpeciesId(int otherSpeciesId) {
        this.otherSpeciesId = otherSpeciesId;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
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
