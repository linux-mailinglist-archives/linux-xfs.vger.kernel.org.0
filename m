Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCFC484AEE
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jan 2022 23:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiADW4G (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jan 2022 17:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbiADW4F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 17:56:05 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D204C061784
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 14:56:05 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id f5so4553636pgk.12
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jan 2022 14:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QDrla7Rgv/PbJy5q1B/gTLicO7LUJ4Uh87OcS/ewnKE=;
        b=UnQWpQr21b08H9CCzMDJ58NV59i32gSxpHT+QzAwkrO4OAmJ//j0XPMmeqp9ezNcVD
         wc+LG30An/agayNvl+NJHt6YBjXm6O408MGhsYl9h7mvor6IRClKKERwR+G7NA4rrrxD
         YEhHssP/S9/5wHZr2A6Ly4Y41OVCTab/vh3T/47v9/0Zl1rBfzSzhFxVXZwEhpw+OAlb
         lHdxMEYtx8koB4EsWoqsmItGdKo9eHAhy8j0Jf078FeDyQ6lYITt2LM67Tetu3wYlKWG
         m/cVqQ6dQgccJh3/k7W1YuPpUIzvCRVDDwWPDHRnOkQXBz8LQPfn4BPfDg0xP1ivy5we
         53Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QDrla7Rgv/PbJy5q1B/gTLicO7LUJ4Uh87OcS/ewnKE=;
        b=A7z6GjGx+HrAuQQ/gK0YBOzBkbTpMMpFJro6t2USsbRPDCm3m0WhM58nx4YHzVQ0Ir
         ospFiWh6v6JYck2ytx6GzLTeQWn+5bGqTfLAtZh52rU9pwDLQZVWbrpth/5oE8TJfN+p
         erAz9YzW7im4LRYDwQxsAk3PPpgic3UmOQatlRTqyan8AEmCI0do6CHjRveWZNoicLl6
         DzE8IfFTXfR2cWfmNp8Yoe3iubrzLg2nklZsjh9fPhw8VJ5bW8NTsE+1ZqFQ4YViHZXP
         nKtzoaYPHnpkKAnW7hIwaY1yu1ZG7iGgLPcXJK72dQpiqElLg/yHql6iJcuWXi6Ip8D8
         5cag==
X-Gm-Message-State: AOAM532QfqIDWIxKgFy5Buy1cVjDukTepTqjw/yd2clQ+B6JWuo4OD22
        UfESlLc6vh6nXkP/JYtlBzi38r9pK92tJE2nI3mAzw==
X-Google-Smtp-Source: ABdhPJw+Vos8Ml12UKdWDConJMoM6GI2KsSQYifbyzS1cJDllpf9uH/RB9uuvuXF/vjErHmErkc/FI0EcnSktAhTHJQ=
X-Received: by 2002:a63:79c2:: with SMTP id u185mr904600pgc.74.1641336965053;
 Tue, 04 Jan 2022 14:56:05 -0800 (PST)
MIME-Version: 1.0
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com> <20211226143439.3985960-7-ruansy.fnst@fujitsu.com>
In-Reply-To: <20211226143439.3985960-7-ruansy.fnst@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 4 Jan 2022 14:55:54 -0800
Message-ID: <CAPcyv4jVDfpHb1DCW+NLXH2YBgLghCVy8o6wrc02CXx4g-Bv7Q@mail.gmail.com>
Subject: Re: [PATCH v9 06/10] fsdax: Introduce dax_lock_mapping_entry()
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jane Chu <jane.chu@oracle.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 26, 2021 at 6:35 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> The current dax_lock_page() locks dax entry by obtaining mapping and
> index in page.  To support 1-to-N RMAP in NVDIMM, we need a new function
> to lock a specific dax entry corresponding to this file's mapping,index.
> And output the page corresponding to the specific dax entry for caller
> use.

Is this necessary? The point of dax_lock_page() is to ensure that the
fs does not destroy the address_space, or remap the pfn while
memory_failure() is operating on the pfn. In the notify_failure case
control is handed to the fs so I expect it can make those guarantees
itself, no?
