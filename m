Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A21F3E69
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2019 04:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfKHDao (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Nov 2019 22:30:44 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34286 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfKHDao (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 22:30:44 -0500
Received: by mail-oi1-f195.google.com with SMTP id l202so4067190oig.1
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 19:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NtB37+Q8xvWyEYnhovPvzQrhxqS2lBLxSLUijnwj9JI=;
        b=FRfas5SPxBMSC4DVisx8MORabFwIgq5lwySDwgKd1CXjN2fmnInTfTzfd/12Zf4kwd
         7s723mPTXcsbd4eONjrHEs1ExgPXRwpD2so5jW/aA0M1j/Mdd21FWzvKz0NNmR8g45UJ
         TSQvt/gLwuJ6jvkLvIFFG99T33Yk9Cuk+48m9VmhXMIrFyIZ5Bs2VqKW3s5qR18L4Zss
         vtb2BBZfNNSJTS8qKcpJnHqR4TdOcX/rVLqIsKfr3LD0e2zcHemW+nGkBXnGKpTnunJz
         GhcE+cPH7t8F31zni88ZgcGawamvuyZxMQMOgqg9KFlYwMrlRm/u/3PmtnsGgfNQZAV+
         TqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NtB37+Q8xvWyEYnhovPvzQrhxqS2lBLxSLUijnwj9JI=;
        b=VQ5yUXZMi0Ym5miSAhU/AESnReyOF/eZofTRlGGbnrpNzR+mMxQqdpCS3qKusT9azM
         S/i4BTH/UgRxacUVAUn/2pq2Az1HFNlekQ3ZSJkPgPu22MVLNEu08Wkm7Ide+MwAVheA
         JKAqHjXIdfvwEPaoP1LRRjeH4HbD+fza8SrUMxUXm4w4Q8vaVWpGYDkhJxPXPYQ9wnJO
         ANT5fp3FzN6hYjv4s5kgHSRc6rH9PR0sVyiXjAs8EPBUmTk/i5UjcOUjJXxTLS5tVlbo
         kyN2ZkYiO7wnl6o1Hii00dyyYXF9IjZ0OqEsUpvQw3JlGWcqHE1uQsr2kx88c/PDRdmk
         uLrw==
X-Gm-Message-State: APjAAAWfgHzkuTLbl73q+Yu/yXAus8Jx+y8/S2folRlH8czcE1YG48ZM
        vECLeYhkHc6tt01TU4UNPV6iyQJKkdXz85T6n8+RJg==
X-Google-Smtp-Source: APXvYqzkdkYe4VeO2i7N7ZYvtM3Hm00GKsbQ7o4949RHdq20XH0TD40W5eXI5rdUew808QiCN7vktLt6WHrVYh8m+0A=
X-Received: by 2002:aca:3d84:: with SMTP id k126mr6733699oia.70.1573183843511;
 Thu, 07 Nov 2019 19:30:43 -0800 (PST)
MIME-Version: 1.0
References: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com> <e33532a2-a9e5-1578-bdd8-a83d4710a151@cn.fujitsu.com>
In-Reply-To: <e33532a2-a9e5-1578-bdd8-a83d4710a151@cn.fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 7 Nov 2019 19:30:32 -0800
Message-ID: <CAPcyv4ivOgMNdvWTtpXw2aaR0o7MEQZ=cDiy=_P9qhVb3QVWdQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/7] xfs: reflink & dedupe for fsdax (read/write path).
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        david <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gujx@cn.fujitsu.com, qi.fuli@fujitsu.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 7, 2019 at 7:11 PM Shiyang Ruan <ruansy.fnst@cn.fujitsu.com> wrote:
>
> Hi Darrick, Dave,
>
> Do you have any comment on this?

Christoph pointed out at ALPSS that this problem has significant
overlap with the shared page-cache for reflink problem. So I think we
need to solve that first and then circle back to dax reflink support.
I'm starting to take a look at that.
