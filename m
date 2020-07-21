Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0210E22831D
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Jul 2020 17:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgGUPFn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Jul 2020 11:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgGUPFn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 11:05:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CEBC061794
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 08:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5MVUtKU0NALlBqFWqFoh5E8gDjRcbSPt+Jwz9Oc0yhE=; b=a85V/JlJ0QH+Y+e/syhKzyyfl+
        DzlgWs/rU4hi/SrcBzHTLU860qmPdr6EPpikiHzQ9FIzUUCQvkLvhrO8zDvXtsfKHweK7wAj0jPv/
        iuxxXVolju+VR8ar++5Dw3enKqesw61055GOac7ch2NbIjWR0slZ5VQoFDXKIu93dl7ndR9chfExa
        HwWe5VcIkbbHMMib7hBkkm3nuwM7Rkw9LVqZI+Qx26O2Anq7o33i8/7M/brteFoJpu2Llhv1QV1Fy
        N13J4ozIzxy1SH2C7eXJnGWaphkEXwTUHuct6QWoRN3Nl5i4CHo4uG1fQmwv8NDqKh5D/R5gpv+fE
        BgyjH0XA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxtpt-0002NE-LH; Tue, 21 Jul 2020 15:05:41 +0000
Date:   Tue, 21 Jul 2020 16:05:41 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Bill O'Donnell <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@sandeen.net,
        darrick.wong@oracle.com
Subject: Re: [PATCH v2 3/3] xfsprogs: xfs_quota state command should report
 ugp grace times
Message-ID: <20200721150541.GB8201@infradead.org>
References: <20200715201253.171356-4-billodo@redhat.com>
 <20200717204314.309873-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717204314.309873-1-billodo@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 17, 2020 at 03:43:14PM -0500, Bill O'Donnell wrote:
> Since grace periods are now supported for three quota types (ugp),
> modify xfs_quota state command to report times for all three.
> Add a helper function for stat reporting.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
