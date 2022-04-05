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

package is.stokkur.afladagbok.android;

import is.stokkur.afladagbok.android.db.entity.StoredPull;
import is.stokkur.afladagbok.android.db.entity.StoredToss;

/**
 * Created by annalaufey on 1/31/18.
 */

public class TestData {
    static final StoredToss STORED_TOSS = new StoredToss(22, "TourId14-Toss2-TossDay0602", "2017-11-24T15:44:22", 56.55, 44.55, 12);

    static final StoredToss STORED_TOSS2 = new StoredToss(11, "TourId14-Toss3-TossDay0602", "2017-11-26T15:44:22", 30.55, 99.55, 4);

    static final StoredPull STORED_PULL = new StoredPull(14, "TourId14-Toss2-TossDay0602", "TourId14-TossIdTourId14-Toss2-TossDay0602-PullId0-PullDay0602", "2018-02-06T16:28:34", 6);
}
