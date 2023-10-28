Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2637DA833
	for <lists+linux-xfs@lfdr.de>; Sat, 28 Oct 2023 19:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjJ1RVI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 28 Oct 2023 13:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjJ1RVH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Oct 2023 13:21:07 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C429E1
        for <linux-xfs@vger.kernel.org>; Sat, 28 Oct 2023 10:21:03 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20231028172100euoutp01bfe8ae7d466f23475538b33fe1eff235~SVSzx9xf22358923589euoutp01E
        for <linux-xfs@vger.kernel.org>; Sat, 28 Oct 2023 17:21:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20231028172100euoutp01bfe8ae7d466f23475538b33fe1eff235~SVSzx9xf22358923589euoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1698513661;
        bh=Z1TI/4Osy7GbGpdJl9V2+WVThZcu4H/02A+56IpW2EE=;
        h=Date:Subject:To:CC:From:In-Reply-To:References:From;
        b=lM3UvSGkYCBxfCdKxNfc4lDZZ2+zHR61WUMSFQ5tdsNiAYnqMTX4m4Sw9Lc9qNBB8
         zT729xvzZcbtkm5vhA4tlxAh4SpfP9jlJ9kzoeHDHlz4gghUnYcGON/ov56jiFDQ4R
         Atjf6xVb5vWxafJ+7d2un3MNJklMxHAivOAnxNyw=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20231028172100eucas1p2796ada9bc8f229bc834e933c6bae7fb6~SVSy-p_RZ2698826988eucas1p2K;
        Sat, 28 Oct 2023 17:21:00 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 36.68.42423.BF24D356; Sat, 28
        Oct 2023 18:21:00 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20231028172059eucas1p23eb0efe3a674ae2cf16cdcd394bae058~SVSyg2krm2696326963eucas1p2H;
        Sat, 28 Oct 2023 17:20:59 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20231028172059eusmtrp1f231668fbe18e7bb5ec2db5329f5244f~SVSygKyyB2883828838eusmtrp1m;
        Sat, 28 Oct 2023 17:20:59 +0000 (GMT)
X-AuditID: cbfec7f2-a3bff7000002a5b7-54-653d42fb4521
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 73.9F.25043.BF24D356; Sat, 28
        Oct 2023 18:20:59 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20231028172059eusmtip1cf9b8a24266cdd588f6fb1903b064aa8~SVSyUTl1F1481114811eusmtip18;
        Sat, 28 Oct 2023 17:20:59 +0000 (GMT)
Received: from [192.168.1.64] (106.210.248.118) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Sat, 28 Oct 2023 18:20:58 +0100
Message-ID: <5e0d5a3b-199e-40aa-b4b8-847819cc1329@samsung.com>
Date:   Sat, 28 Oct 2023 19:20:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: fix iomap_dio_zero() for fs bs > system page
 size
To:     Dave Chinner <david@fromorbit.com>,
        Pankaj Raghav <kernel@pankajraghav.com>
CC:     <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <willy@infradead.org>, <djwong@kernel.org>, <mcgrof@kernel.org>,
        <hch@lst.de>, <da.gomez@samsung.com>, <gost.dev@samsung.com>
Content-Language: en-US
From:   Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <ZTw1X3YdOmBmM+hQ@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [106.210.248.118]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsWy7djPc7p/nGxTDTbvZrTYcuweo8XlJ3wW
        K1cfZbI48/Izi8WevSdZLHb92cFucWPCU0aL3z/msDlweJxaJOGxeYWWx6ZVnWweu282sHmc
        Xeno8XmTXABbFJdNSmpOZllqkb5dAlfG3a3n2QuOs1Z8a/nB2MC4nKWLkYNDQsBEYt5/wy5G
        Lg4hgRWMErvb/rJAOF8YJRZ/XM0K4XxmlJj59ghzFyMnWMeZuzuZIBLLGSW2dtxngav68GE3
        lLOLUeLrlpVMIC28AnYSi9ccYwOxWQRUJaYdbmGGiAtKnJz5hAXEFhWQl7h/awY7iC0s4C9x
        ZO4JsF4RgUCJJ/ePMIIMZRY4zCgx5/l9sCJmAXGJW0/mM4F8wSagJdHYCRbmFDCW+NpxjAWi
        RFOidftvqHJ5ie1v50C9oCxx6skDVgi7VuLUlltg70gIdHNKTNx7ByrhItF/A+JoCQFhiVfH
        t7BD2DISpyf3sEDY1RJPb/xmhmhuYZTo37meDRKs1hJ9Z3Igahwl/t75CA1tPokbbwUh7uGT
        mLRtOvMERtVZSEExC8lns5C8MAvJCwsYWVYxiqeWFuempxYb5qWW6xUn5haX5qXrJefnbmIE
        JqXT/45/2sE499VHvUOMTByMhxglOJiVRHiZHW1ShXhTEiurUovy44tKc1KLDzFKc7AoifOq
        psinCgmkJ5akZqemFqQWwWSZODilGpi6L9Q/uDhr/9wfharPf0zrFNbZ7Gw05dfRT+xMNqt9
        H6vvV0q8L8bJ026pVHPLrlAr9vf3ibN/7dqwpD3i3IxvT9tEvXp4t6y4Unvw/Dr+kgtHf3kt
        n397i67S2/Qn7lYRlvO/d0YIzNI6sP7lh6TCYAvWno7pcz8qfFvgsqFXpCzSS/mBRQU7z58O
        a4XIa3yiQVHROmq1oXvztu0MqV7YUnh6U/t019SNE5+sTRJ48JR7AfOpvHqFo0/7e9+3BdlL
        F3InnXPwE8udnrCEV9HYulmNk2HWkz9V8XUVCYwXXsrc0F3Vcz5e0CRv8+3X07r/xh00/bHj
        zvkjPz2Xl1/9aKDMytVbmCx8wHd13H4lluKMREMt5qLiRAAXGtAluQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/xu7q/nWxTDf5tU7DYcuweo8XlJ3wW
        K1cfZbI48/Izi8WevSdZLHb92cFucWPCU0aL3z/msDlweJxaJOGxeYWWx6ZVnWweu282sHmc
        Xeno8XmTXABblJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYmlnqGxeayVkamSvp1NSmpOZllq
        kb5dgl7G3a3n2QuOs1Z8a/nB2MC4nKWLkZNDQsBE4szdnUxdjFwcQgJLGSVO733DBpGQkdj4
        5SorhC0s8edaF1hcSOAjo8T/kzkQDbsYJT79OcgOkuAVsJNYvOYYWBGLgKrEtMMtzBBxQYmT
        M5+AbRMVkJe4f2sGWL2wgK/Enol3wGwRgUCJJ/ePMIIMZRY4zCgx5/l9dogNuxklVq+7wQRS
        xSwgLnHryXwgm4ODTUBLorETrJlTwFjia8cxFogSTYnW7b/ZIWx5ie1v5zBDfKAscerJA6hv
        aiU+/33GOIFRdBaS+2Yh2TALyahZSEYtYGRZxSiSWlqcm55bbKRXnJhbXJqXrpecn7uJERjL
        24793LKDceWrj3qHGJk4GA8xSnAwK4nwMjvapArxpiRWVqUW5ccXleakFh9iNAUG0kRmKdHk
        fGAyySuJNzQzMDU0MbM0MLU0M1YS5/Us6EgUEkhPLEnNTk0tSC2C6WPi4JRqYFqRPNdyY0jK
        /xeuG6p6PlrMZX/lWHJAaL7pxTXBlVnv7Y/z13xWvHy4rqbF5fCK0tAkrqSWBQ2tHlleihm7
        1u/P8VX+73fufNSnlHpu8xx726eML1c68qp7fTC490Jwgk2xe4z/G1l/CwGLhA7jgkV7lvl1
        XLBndbnD9yz7+yevyzEmcrqm/O27ImZf2vv2yOXA+m1fFXrL5thqBB6fINqxrCb0Z39W0uFS
        jlvfQ7Qaol49ORnT0MDg+11j5TrHL5f/Pnp6LWhO0zXLF1ErjX5XLxQ3stlUtXzOioS3fJsr
        0wu/frrEMf94akMF+/qTlUnH33bq7wk/H/H6YKaReuwaM5dXf2Y3VupwlTKeU2Ipzkg01GIu
        Kk4EAFV8kepuAwAA
X-CMS-MailID: 20231028172059eucas1p23eb0efe3a674ae2cf16cdcd394bae058
X-Msg-Generator: CA
X-RootMTR: 20231027221047eucas1p15c503b4fe4f4f1799a3f85ab00490010
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20231027221047eucas1p15c503b4fe4f4f1799a3f85ab00490010
References: <20231026140832.1089824-1-kernel@pankajraghav.com>
        <CGME20231027221047eucas1p15c503b4fe4f4f1799a3f85ab00490010@eucas1p1.samsung.com>
        <ZTw1X3YdOmBmM+hQ@dread.disaster.area>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>> Fixes: db074436f421 ("iomap: move the direct IO code into a separate file")
> 
> I forgot to mention - this fixes tag is completely bogus. That's
> just a commit that moves the code from one file to another and
> there's no actual functional change at all.
> 
> Further, this isn't a change that "fixes" a bug or regression - it
> is a change to support new functionality that doesnt' yet exist
> upstream, and so there is no bug in the existing kernels for it to
> fix....

I agree. I will remove the Fixes tag.

I added it as iomap infra does not explicitly tell it does not
support the LBS usecase. But I agree that it is a change to support
a new feature, and it shouldn't go as a fix.

