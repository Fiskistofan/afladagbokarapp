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

package is.stokkur.afladagbok.android.terms;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

public class PrivacyTermsResponse
        implements Parcelable {

    @SerializedName("privacyTerms")
    public PrivacyTerms mTerms = null;

    @SerializedName("needsToAgree")
    public boolean mNeedsToAgree = false;

    public PrivacyTermsResponse() {

    }

    public PrivacyTermsResponse(Parcel in) {
        mTerms = in.readParcelable(PrivacyTerms.class.getClassLoader());
        mNeedsToAgree = in.readInt() == 1;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeParcelable(mTerms, flags);
        dest.writeInt(mNeedsToAgree ? 1 : 0);
    }

    static final public Parcelable.Creator<PrivacyTermsResponse> CREATOR
            = new Parcelable.Creator<PrivacyTermsResponse>() {
        public PrivacyTermsResponse createFromParcel(Parcel in) {
            return new PrivacyTermsResponse(in);
        }

        public PrivacyTermsResponse[] newArray(int size) {
            return new PrivacyTermsResponse[size];
        }
    };

}
