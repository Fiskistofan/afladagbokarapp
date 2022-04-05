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

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

public class RestrictedZone {

    @SerializedName("id")
    public long mId = -1L;

    @SerializedName("name")
    public String mName = null;

    @SerializedName("officialDescription")
    public String mOfficialDescription = null;

    @SerializedName("reason")
    public String mReason = null;

    @SerializedName("dateFrom")
    public String mFrom = null;

    @SerializedName("dateTo")
    public String mTo = null;

    @SerializedName("coordinates")
    public ArrayList<Coordinate> mCoordinates = null;

    @SerializedName("fishingGear")
    public ArrayList<String> mFishingGear = null;

    @SerializedName("species")
    public ArrayList<String> mSpecies = null;

}
