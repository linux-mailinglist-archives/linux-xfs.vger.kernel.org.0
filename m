Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1A924E624
	for <lists+linux-xfs@lfdr.de>; Sat, 22 Aug 2020 09:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgHVHpr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 22 Aug 2020 03:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgHVHpp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 03:45:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616D8C061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 00:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=VxhHAns/H8yeSDOC7K8Vec/zEo
        uC8BYfOn2ihn9jdtmnOLyGoRG1oIfR8JfpAN6fVWcYRjBZMj74i2ZS50a+uZ1Lwo70z7t2Ew6Y3Am
        I8eYcT3XzeDGFHlTPcgvNMDQhMIjltiFltI67bqKAyzdWY5tUj5m291dRIwAE/DwT7G9IFcxBC8FN
        i8B3NHO7u98W3ooI+gHxm8ywDxKNAXMWggikU0Swm8jsT56AQUu4WMRCzIbJMiMVZRLgvpq+lGJy3
        gD/JmHZ450+OYRWVuEa2N9L4Lz8c7y407DExvfRQndmMFVIzsfLMfxbTdgHv6GY5jpd+a0GvudH2Q
        2bLnRYYg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9ODf-0002lk-Ul; Sat, 22 Aug 2020 07:45:43 +0000
Date:   Sat, 22 Aug 2020 08:45:43 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs: factor the xfs_iunlink functions
Message-ID: <20200822074543.GB8859@infradead.org>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
