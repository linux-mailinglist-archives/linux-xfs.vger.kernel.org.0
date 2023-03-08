Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC1E6AFF26
	for <lists+linux-xfs@lfdr.de>; Wed,  8 Mar 2023 07:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjCHGz1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 Mar 2023 01:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjCHGzY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 01:55:24 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5079BE3C
        for <linux-xfs@vger.kernel.org>; Tue,  7 Mar 2023 22:55:22 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id cy23so61579968edb.12
        for <linux-xfs@vger.kernel.org>; Tue, 07 Mar 2023 22:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678258520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t70odTwmK6O77z83bIqLAvXxKp0qE+ApIEsl/k0TwRg=;
        b=SvJRYpGbYBjKv59H4HCKsI7FHXUk8wNeT5ln9OF9p4Yo/DzY3x+JBriHlUCsLHkbLx
         uHAd7HHnZs0HddC1hWysXar5oL4ukgo/NxGJ1wHVSC6czBH1euLkijk1EOW7+Sww2Z8D
         cUoOFf5GHkzBlSvQ04vt5G4UBXvzz0wyCHSZTsrPaUV8ptoJoHjnZwVBZuVm8Q9gnRVj
         wrRPSR0xKEskGh/0nSPNtRDNdYx0vvgjbeyLF8NumIBinb2rdsXWQKYiG8dIcOQLYSf7
         t1D/nGvITRdRK8fmju2RQ7t6cDKNmxR2RdOKMy/7/Qy3fhn2/EdDNb3dgGy7vU2RY/OE
         0qEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678258520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t70odTwmK6O77z83bIqLAvXxKp0qE+ApIEsl/k0TwRg=;
        b=bCUjZAaNzgZgPPUoEn//bsDmXE1i5jIjxzJyO2Aec38ev913wClAsJgKFl/vtI1B+4
         /gstLK7/vRWC/uBhIwNn/F4HrRmfzZJBnW+bL0m8OFR6S08jnH1QPlFuwdMlf+fZRw6m
         K28qYB8hkTuMDjpvoqKUjINvI3YnYJIIsbfphBR9cSAP/LdDvPKnMzpWcpc13PgpmggM
         4RqgIeItrEvljRCubUU67MfFJJ7+6Q6ApmO4uyQOSkgNtsWGUKTu0FvOO3dGB1jXMIVb
         Z9tI+euudVx875AzXiIOUASfigoy/IKybSLhsE7LY/dF2aD5RJvZ1OnMlB71pK6pNQEC
         kfhA==
X-Gm-Message-State: AO0yUKXFTDVczZEg11FjI0aSzUa8EULBNtlJUmB5O3Av4Y0pyGZLx3j2
        66tq3MCqYfC6Z5U31B+lXqhDzYLfZtYgN3gg/UGJXg==
X-Google-Smtp-Source: AK7set84EqwKbbWtBzLqoI2WBaXzcxS36AWRY3R571B29UifEtRwl/Oaa3UiGOLEMSR+VMGnJ9LPtwdL8OLwQH7/Z6w=
X-Received: by 2002:a50:8750:0:b0:4c2:ed2:1196 with SMTP id
 16-20020a508750000000b004c20ed21196mr9453336edv.5.1678258520463; Tue, 07 Mar
 2023 22:55:20 -0800 (PST)
MIME-Version: 1.0
References: <20230228085002.2592473-1-yosryahmed@google.com>
In-Reply-To: <20230228085002.2592473-1-yosryahmed@google.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 7 Mar 2023 22:54:44 -0800
Message-ID: <CAJD7tkbjidNgKi1RLOyVks-RR34mXh+QkKf_BZY_ZcMrjfP0TQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] Ignore non-LRU-based reclaim in memcg reclaim
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 28, 2023 at 12:50=E2=80=AFAM Yosry Ahmed <yosryahmed@google.com=
> wrote:
>
> Reclaimed pages through other means than LRU-based reclaim are tracked
> through reclaim_state in struct scan_control, which is stashed in
> current task_struct. These pages are added to the number of reclaimed
> pages through LRUs. For memcg reclaim, these pages generally cannot be
> linked to the memcg under reclaim and can cause an overestimated count
> of reclaimed pages. This short series tries to address that.
>
> Patch 1 is just refactoring updating reclaim_state into a helper
> function, and renames reclaimed_slab to just reclaimed, with a comment
> describing its true purpose.
>
> Patch 2 ignores pages reclaimed outside of LRU reclaim in memcg reclaim.
> The pages are uncharged anyway, so even if we end up under-reporting
> reclaimed pages we will still succeed in making progress during
> charging.
>
> Do not let the diff stat trick you, patch 2 is a one-line change. All
> the rest is moving a couple of functions around and a huge comment :)
>
> RFC -> v1:
> - Exported report_freed_pages in case XFS is built as a module (Matthew
>   Wilcox).
> - Renamed reclaimed_slab to reclaim in previously missed MGLRU code.
> - Refactored using reclaim_state to update sc->nr_reclaimed into a
>   helper and added an XL comment explaining why we ignore
>   reclaim_state->reclaimed in memcg reclaim (Johannes Weiner).
>
> Yosry Ahmed (2):
>   mm: vmscan: refactor updating reclaimed pages in reclaim_state
>   mm: vmscan: ignore non-LRU-based reclaim in memcg reclaim
>
>  fs/inode.c           |  3 +-
>  fs/xfs/xfs_buf.c     |  3 +-
>  include/linux/swap.h |  5 ++-
>  mm/slab.c            |  3 +-
>  mm/slob.c            |  6 ++--
>  mm/slub.c            |  5 ++-
>  mm/vmscan.c          | 79 +++++++++++++++++++++++++++++++++++---------
>  7 files changed, 74 insertions(+), 30 deletions(-)
>
> --
> 2.39.2.722.g9855ee24e9-goog
>

Friendly ping on this series, any comments or thoughts -- especially
on the memcg side?
