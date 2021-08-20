Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1632C3F314C
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Aug 2021 18:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhHTQMm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 Aug 2021 12:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbhHTQM3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Aug 2021 12:12:29 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79651C061155
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 09:07:41 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id c17so9631832pgc.0
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 09:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=epIvCzmEqd8lfEkp+zSX1z8FhC6G4rECGu8AkMD5cjk=;
        b=P7Uh70GB0OX3B5Tk5r5zIxGh0NGQ540vdB1mNKc2+JutGdaZMDOkgUxO7d7iWDuhYZ
         z1tCB9283izawrMkSTNVGS7wgAXNGmlA3+Cr1pWkT1AUl7J8yzzbAfduwNz8D3V9fHfW
         6RZt94rmopS/jx/A8V3arfNqYRWF4Gb2BH8IG7P2QkRuA12Qi+9LAd16WMy1VBKta2EW
         6fU2eSUDVOsSjU2nRgaifSK1mQmCZIk5O3n/hYxktE56ZNMrEERZzMgxXuvQoedf5AQ1
         +n2gl1cUovGWZFtsMrCPt+gUTucffn2xvgJEpGG8k+mhCO/9SqQlDQ6VWtpgkGfa16cD
         fs1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=epIvCzmEqd8lfEkp+zSX1z8FhC6G4rECGu8AkMD5cjk=;
        b=VQZPGy4lq57XHqZ6yjYvnhbzmPC6Xepck+UsXn+Nwvide+Sg15QD6IT8+aUXHELsUD
         H+5kJaNLam9ITEpQGM3caBYqoVTeCCjLQdfbenvcRhoKk4EgqHR37HPi7e5OjLIo+UrV
         PcSFj6iPAVb/806Fnh+MmRgGNQUZsbesTZ0xHbO9xQODNLDrm/gP44YuFNUNnvaz5LmW
         5uKqbK6+PNZAzLOH3DP69OOUzgW5j3wUXwg4h/EcBoQ+14OWvmCa/xX8X0w0jxGBNqKY
         6YFV8n36b191AIKK3VMdqfwstQTAt1nkTM+jrpKaBdYt2xLvYfeJjWH9LhmnfBh0/syq
         bP0A==
X-Gm-Message-State: AOAM532JoBpEHZKXEZf89CeVODgchLVBeM49bhYU2JXWZ+4WkwMT+U+b
        qxXZtuLWk0vTz7LK3d7nk7mTcyuHkSvHShIgrn+4SA==
X-Google-Smtp-Source: ABdhPJxyfy7kK0en0qSo4G5Lluu8ZezasgOhs9PpGIhkynMyXLeeasrkdLx8NF/nNzuMhI/nhpOTrwat9vU59+Lgzvc=
X-Received: by 2002:a05:6a00:9a4:b0:3e2:f6d0:c926 with SMTP id
 u36-20020a056a0009a400b003e2f6d0c926mr13253034pfg.31.1629475661105; Fri, 20
 Aug 2021 09:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com> <20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 20 Aug 2021 09:07:30 -0700
Message-ID: <CAPcyv4h0p+zD5tsT8HDUpNq_ZDCqo249KsmPLX-U8ia146r2Tg@mail.gmail.com>
Subject: Re: [PATCH RESEND v6 1/9] pagemap: Introduce ->memory_failure()
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 30, 2021 at 3:02 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> When memory-failure occurs, we call this function which is implemented
> by each kind of devices.  For the fsdax case, pmem device driver
> implements it.  Pmem device driver will find out the filesystem in which
> the corrupted page located in.  And finally call filesystem handler to
> deal with this error.
>
> The filesystem will try to recover the corrupted data if necessary.

This patch looks good to me, but I would fold it into the patch that
first populates ->memory_failure().
