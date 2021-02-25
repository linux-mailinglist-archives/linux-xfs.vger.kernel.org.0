Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D6D324CA3
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Feb 2021 10:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhBYJTf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Feb 2021 04:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236093AbhBYJQU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 04:16:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EF2C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 01:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=vyMtXfxTmQpuBvLC/B6FWl/rm3
        avDVMifrE20pY3mqCzafmleJuShmHDSX+v9rWF4YCtqgcR0XMiktP5kTp7V33prhf9u+Ptk7uZpPG
        ruzKpojkPUVc6eguOwsuYdCuxsdzdlIuA76kKNI95wRZ562rSAELyQDGj2pdYWHLidhuzERbmaeVO
        mfjCyi2IOBkA54+zix9P9jEf1qXnJJlNFgNj/JKQK+fS/dlTAjAkDIVZe23ajUwtpyVVEtPpOrTK+
        go6sXnHRzarVbr8OAySh0fyQ4TEa/mxhja5tFaWuUnqJC4xr0VPWasfaPt0VjK8MMBAnuD6Z0wTN2
        jJCgD5/A==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFCjg-00AVel-Mk; Thu, 25 Feb 2021 09:15:15 +0000
Date:   Thu, 25 Feb 2021 10:12:52 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/13] xfs: factor out the CIL transaction header building
Message-ID: <YDdqFI4cKImzpF+f@infradead.org>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224063459.3436852-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
