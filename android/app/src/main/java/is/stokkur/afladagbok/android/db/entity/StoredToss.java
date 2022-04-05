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
import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by annalaufey on 1/31/18.
 */

@Entity(tableName = "storedToss")
public class StoredToss
        implements Parcelable {

    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    private int id;

    @ColumnInfo(name = "tourId")
    private int tourId;

    @ColumnInfo(name = "tossId")
    private String tossId;

    @ColumnInfo(name = "dateTime")
    private String dateTime;

    @ColumnInfo(name = "latitude")
    private double latitude;

    @ColumnInfo(name = "longitude")
    private double longitude;

    @ColumnInfo(name = "count")
    private int count;

    @ColumnInfo(name = "sent")
    private boolean sent;

    @ColumnInfo(name = "pulledCount")
    private int pulledCount;

    @ColumnInfo(name = "equipmentTypeId")
    private int equipmentTypeId;

    public StoredToss(int tourId, String tossId, String dateTime, double latitude, double longitude,
                      int count, int pulledCount, int equipmentTypeId) {
        this.tourId = tourId;
        this.tossId = tossId;
        this.dateTime = dateTime;
        this.latitude = latitude;
        this.longitude = longitude;
        this.count = count;
        this.pulledCount = pulledCount;
        this.equipmentTypeId = equipmentTypeId;
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

    public String getTossId() {
        return tossId;
    }

    public void setTossId(String tossId) {
        this.tossId = tossId;
    }

    public String getDateTime() {
        return dateTime;
    }

    public void setDateTime(String dateTime) {
        this.dateTime = dateTime;
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

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public boolean isSent() {
        return sent;
    }

    public void setSent(boolean sent) {
        this.sent = sent;
    }

    public int getPulledCount() {
        return pulledCount;
    }

    public void setPulledCount(int pulledCount) {
        this.pulledCount = pulledCount;
    }

    public int getEquipmentTypeId() {
        return equipmentTypeId;
    }

    public void setEquipmentTypeId(int equipmentTypeId) {
        this.equipmentTypeId = equipmentTypeId;
    }

    private StoredToss(Parcel in) {
        id = in.readInt();
        tourId = in.readInt();
        tossId = in.readString();
        dateTime = in.readString();
        latitude = in.readDouble();
        longitude = in.readDouble();
        count = in.readInt();
        sent = in.readInt() == 1;
        pulledCount = in.readInt();
        equipmentTypeId = in.readInt();
    }

    static final public Parcelable.Creator<StoredToss> CREATOR
            = new Parcelable.Creator<StoredToss>() {
        public StoredToss createFromParcel(Parcel in) {
            return new StoredToss(in);
        }

        public StoredToss[] newArray(int size) {
            return new StoredToss[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(id);
        dest.writeInt(tourId);
        dest.writeString(tossId);
        dest.writeString(dateTime);
        dest.writeDouble(latitude);
        dest.writeDouble(longitude);
        dest.writeInt(count);
        dest.writeInt(sent ? 1 : 0);
        dest.writeInt(pulledCount);
        dest.writeInt(equipmentTypeId);
    }

}
