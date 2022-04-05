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
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import androidx.collection.ArrayMap;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.MainActivity;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.db.entity.StoredAnimalCatch;
import is.stokkur.afladagbok.android.db.entity.StoredFishCatch;
import is.stokkur.afladagbok.android.models.FishAndAnimalCatch;
import is.stokkur.afladagbok.android.utils.Keys;
import is.stokkur.afladagbok.android.utils.SpeciesID;
import is.stokkur.afladagbok.android.utils.Utils;

/**
 * Created by annalaufey on 11/10/17.
 */

public class BookFragment extends BaseFragment implements ChangeRegistryClickListener {


    @BindView(R.id.registered_catch_recycler_view)
    RecyclerView recyclerView;
    @BindView(R.id.nothing_registered_layout)
    LinearLayout nothingRegisteredLayout;

    private FloatingActionButton mAddCatchFab = null;

    RegisteredCatchAdapter adapter;
    BookViewModel viewModel;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.book_fragment, container, false);
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        nothingRegisteredLayout.setOnClickListener(v -> addCatch());
        mAddCatchFab = view.findViewById(R.id.book_fragment_add_catch_fab);
        mAddCatchFab.setVisibility(View.GONE);
        mAddCatchFab.setOnClickListener(v -> addCatch());
    }

    public void addCatch() {
        Intent intent = new Intent(getActivity(), BookCatchActivity.class);
        startActivity(intent);
    }

    @Override
    public void onResume() {
        super.onResume();
        setupViewModel();
    }

    /**
     * Gets the MainViewModel and register observer(s)
     * Observes the catches and updates the recycler view if the catch database
     * is updated.
     */
    private void setupViewModel() {
        final List<FishAndAnimalCatch> storedFishCatchesList = new ArrayList<>();
        initRecyclerView(storedFishCatchesList);
        viewModel = ViewModelProviders.of(this).get(BookViewModel.class);

        viewModel.getAllFishCatchForTour().observe(this,
                (List<StoredFishCatch> storedFishCatches) -> {
                    if (storedFishCatches != null) {
                        String catchId;
                        StoredFishCatch fishCatch;
                        StoredFishCatch storedFishCatch;
                        int size = storedFishCatches.size();
                        final ArrayMap<String, StoredFishCatch> map = new ArrayMap<>();

                        for (int i = 0; i < size; ++i) {
                            storedFishCatch = storedFishCatches.get(i);
                            catchId = storedFishCatch.getCatchId();

                            fishCatch = map.get(catchId);
                            if (fishCatch == null) {
                                fishCatch = storedFishCatch;
                            } else {
                                if (fishCatch.getId() < storedFishCatch.getId()) {
                                    fishCatch = storedFishCatch;
                                }
                            }
                            map.put(catchId, fishCatch);
                        }

                        int index;
                        FishAndAnimalCatch item;
                        size = storedFishCatchesList.size();
                        for (StoredFishCatch value : map.values()) {
                            index = -1;
                            for (int i = 0; i < size; ++i) {
                                item = storedFishCatchesList.get(i);
                                if (item.getCatchId().equals(value.getCatchId())) {
                                    index = i;
                                    break;
                                }
                            }
                            if (index != -1) {
                                storedFishCatchesList.set(index,
                                        new FishAndAnimalCatch(SpeciesID.FISH, value));
                            } else {
                                storedFishCatchesList.add(
                                        new FishAndAnimalCatch(SpeciesID.FISH, value));
                            }
                        }
                    }
                    sortListAndUpdateUI(storedFishCatchesList);
                });

        viewModel.getAllAnimalCatchForTour().observe(this,
                (List<StoredAnimalCatch> storedAnimalCatches) -> {
                    if (storedAnimalCatches != null) {
                        String catchId;
                        StoredAnimalCatch animalCatch;
                        StoredAnimalCatch storedAnimalCatch;
                        int size = storedAnimalCatches.size();
                        final ArrayMap<String, StoredAnimalCatch> map = new ArrayMap<>();

                        for (int i = 0; i < size; ++i) {
                            storedAnimalCatch = storedAnimalCatches.get(i);
                            catchId = storedAnimalCatch.getCatchId();

                            animalCatch = map.get(catchId);
                            if (animalCatch == null) {
                                animalCatch = storedAnimalCatch;
                            } else {
                                if (animalCatch.getId() < storedAnimalCatch.getId()) {
                                    animalCatch = storedAnimalCatch;
                                }
                            }
                            map.put(catchId, animalCatch);
                        }

                        int index;
                        FishAndAnimalCatch item;
                        size = storedFishCatchesList.size();
                        for (StoredAnimalCatch value : map.values()) {
                            index = -1;
                            for (int i = 0; i < size; ++i) {
                                item = storedFishCatchesList.get(i);
                                if (item.getCatchId().equals(value.getCatchId())) {
                                    index = i;
                                    break;
                                }
                            }
                            if (index != -1) {
                                storedFishCatchesList.set(index,
                                        new FishAndAnimalCatch(SpeciesID.FISH, value));
                            } else {
                                storedFishCatchesList.add(
                                        new FishAndAnimalCatch(SpeciesID.FISH, value));
                            }
                        }
                    }
                    sortListAndUpdateUI(storedFishCatchesList);
                });
    }

    private void sortListAndUpdateUI(List<FishAndAnimalCatch> storedFishCatchesList) {
        Collections.sort(storedFishCatchesList, Utils.dateComparator);

        double totalWeight = 0d;
        FishAndAnimalCatch caught;
        int size = storedFishCatchesList.size();
        for (int i = 0; i < size; ++i) {
            caught = storedFishCatchesList.get(i);
            if (caught.getSpeciesType() == SpeciesID.FISH) {
                totalWeight += caught.getWeight();
            }
        }
        try {
            MainActivity activity = (MainActivity) getActivity();
            activity.setTotalWeight(totalWeight);
        } catch (Exception ex) {
            // Empty
        }

        if (size > 0) {
            mAddCatchFab.setVisibility(View.VISIBLE);
            nothingRegisteredLayout.setVisibility(View.GONE);
        } else {
            mAddCatchFab.setVisibility(View.GONE);
            nothingRegisteredLayout.setVisibility(View.VISIBLE);
        }
        adapter.notifyDataSetChanged();
    }

    /**
     * Initialize the scroll view
     *
     * @param registeredCatch
     */
    private void initRecyclerView(List<FishAndAnimalCatch> registeredCatch) {
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity());
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        recyclerView.setLayoutManager(linearLayoutManager);
        adapter = new RegisteredCatchAdapter(registeredCatch, getActivity());
        adapter.setListener(this);
        recyclerView.setAdapter(adapter);
    }

    @Override
    public void changeRegistry(String catchId) {
        Intent intent = new Intent(getActivity(), BookCatchActivity.class);
        intent.putExtra(Keys.CHANGE_REGISTRY, true);
        intent.putExtra(Keys.SELECTED_CHANGE_CATCH, catchId);
        startActivity(intent);
    }

}
