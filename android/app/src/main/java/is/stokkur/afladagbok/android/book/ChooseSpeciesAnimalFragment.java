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
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.collection.ArrayMap;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Editable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;

import com.google.gson.reflect.TypeToken;

import java.text.Collator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Map;

import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.models.Species;
import is.stokkur.afladagbok.android.utils.GsonInstance;
import is.stokkur.afladagbok.android.utils.Persistence;
import is.stokkur.afladagbok.android.utils.SpeciesID;
import is.stokkur.afladagbok.android.widget.TextWatcherAdapter;

public class ChooseSpeciesAnimalFragment
        extends BaseFragment
        implements SpeciesSelectedListener {

    BookViewModel viewModel;
    private SpeciesDetailAdapter mAdapter;
    EditText input;
    ImageView clearSearch;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater,
                             @Nullable ViewGroup container,
                             Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_choose_species_animal, container, false);
    }

    @Override
    public void onViewCreated(View view,
                              @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        viewModel = ViewModelProviders.of(getActivity()).get(BookViewModel.class);
        viewModel.mView = this;

        loadRecentsData();
        ArrayList<Species> species = sortSpecies(viewModel.getSpeciesList());

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity());
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        RecyclerView recyclerView = view.findViewById(R.id.choose_species_animal_list);
        recyclerView.setLayoutManager(linearLayoutManager);

        mAdapter = new SpeciesDetailAdapter(species, getActivity(), viewModel.getSpeciesId(), this);
        recyclerView.setAdapter(mAdapter);

        input = view.findViewById(R.id.choose_species_animal_input);
        input.addTextChangedListener(new TextWatcherAdapter() {
            @Override
            public void afterTextChanged(Editable text) {
                super.afterTextChanged(text);
                mAdapter.getFilter().filter(text);
                clearSearch.setVisibility(text.length()>0?View.VISIBLE:View.GONE);
            }
        });
        clearSearch = view.findViewById(R.id.clear_search);
        clearSearch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                input.setText("");
            }
        });
        input.requestFocus();
    }

    @Override
    public void onPause() {
        super.onPause();
        saveRecentsData();
    }

    @Override
    public void SelectSpecies(Species species) {
        updateRecentsData(species.getId());
        viewModel.setSelectedSpecies(species);
        ((BookCatchActivity) getActivity()).
                replaceFragmentWithAnimation(new ChooseDetailSpeciesFragment());
        mAdapter.getFilter().filter("");
    }

    // --- Recents --- //

    private String mPersistenceKey;
    private ArrayMap<Integer, Long> mRecentsMap = new ArrayMap<>();
    private Collator mSpeciesCollator = Collator.getInstance();
    private Comparator<Species> mSpeciesComparator = (o1, o2) -> {
        long time1 = 0;
        int id1 = o1.getId();
        if (mRecentsMap.containsKey(id1)) {
            time1 = mRecentsMap.get(id1);
        }
        long time2 = 0;
        int id2 = o2.getId();
        if (mRecentsMap.containsKey(id2)) {
            time2 = mRecentsMap.get(id2);
        }
        if (time1 == time2) {
            return mSpeciesCollator.compare(o1.getSpeciesName(), o2.getSpeciesName());
        } else if (time1 == 0) {
            return 1;
        } else if (time2 == 0) {
            return -1;
        } else {
            return (int) (time2 - time1);
        }
    };

    private void loadRecentsData() {
        mPersistenceKey = viewModel.getSpeciesId() == SpeciesID.FISH ?
                Persistence.KEY_RECENT_FISH :
                Persistence.KEY_RECENT_MAMMALS_AND_BIRDS;

        mSpeciesCollator.setStrength(Collator.NO_DECOMPOSITION);
        String recentsJson = Persistence.getStringValue(mPersistenceKey);
        TypeToken<ArrayMap<Integer, Long>> typeToken = new TypeToken<ArrayMap<Integer, Long>>() {
        };
        ArrayMap<Integer, Long> fromJson = GsonInstance.sInstance.
                fromJson(recentsJson, typeToken.getType());
        if (fromJson != null) {
            mRecentsMap.putAll((Map<Integer, Long>) fromJson);
        }
    }

    private ArrayList<Species> sortSpecies(ArrayList<Species> species) {
        Collections.sort(species, mSpeciesComparator);
        return species;
    }

    private void saveRecentsData() {
        String recentsJson = GsonInstance.sInstance.toJson(mRecentsMap);
        Persistence.saveStringValue(mPersistenceKey, recentsJson);
    }

    private void updateRecentsData(int id) {
        long count = 0;
        if (mRecentsMap.containsKey(id)) {
            count = mRecentsMap.get(id);
        }
        mRecentsMap.put(id, ++count);
    }

    // --- Recents --- //

}
