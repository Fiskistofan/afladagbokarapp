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

package com.mapbox.mapboxsdk.annotations;

import android.graphics.Bitmap;
import android.os.Parcel;
import android.os.Parcelable;

import com.mapbox.mapboxsdk.geometry.LatLng;

import java.lang.reflect.Field;

public class MarkerMetaDataOptions<T extends Parcelable>
        extends BaseMarkerOptions<MarkerMetaData<T>, MarkerMetaDataOptions<T>> {

    protected T mMetaData;

    public MarkerMetaDataOptions() {

    }

    private MarkerMetaDataOptions(Parcel in) {
        title(in.readString());
        position(in.readParcelable(LatLng.class.getClassLoader()));
        snippet(in.readString());

        String iconId = in.readString();
        Bitmap iconBitmap = in.readParcelable(Bitmap.class.getClassLoader());
        Icon icon = new Icon(iconId, iconBitmap);
        icon(icon);

        try {
            Field field = getClass().getField("mMetaData");
            Class<?> type = field.getType();
            metaData(in.readParcelable(type.getClassLoader()));
        } catch (Exception ex) {
            // Fuck it failed
            metaData(null);
        }
    }

    @Override
    public MarkerMetaDataOptions<T> getThis() {
        return this;
    }

    @Override
    public MarkerMetaData<T> getMarker() {
        return new MarkerMetaData<>(this);
    }

    static final public Parcelable.Creator<MarkerMetaDataOptions> CREATOR
            = new Parcelable.Creator<MarkerMetaDataOptions>() {
        public MarkerMetaDataOptions createFromParcel(Parcel in) {
            return new MarkerMetaDataOptions(in);
        }

        public MarkerMetaDataOptions[] newArray(int size) {
            return new MarkerMetaDataOptions[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(title);
        dest.writeParcelable(position, flags);
        dest.writeString(snippet);
        dest.writeString(icon.getId());
        dest.writeParcelable(icon.getBitmap(), flags);
        dest.writeParcelable(mMetaData, flags);
    }

    public MarkerMetaDataOptions<T> metaData(T metaData) {
        mMetaData = metaData;
        return this;
    }

}
