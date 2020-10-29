Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE1529E7C6
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 10:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgJ2JtO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 05:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgJ2JtO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:49:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4E0C0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FVUbO6ZU+K9B6BdgJRHq/4S4TFBi9qXofujGwbwed5U=; b=uqjG6uQFxaOV2C3K9hYSBF3VBv
        LdQHhP8BYKTWO2DFzFWOseRntdZ6iccLJeN/i/f3MfxRS6KPbO80VMW6xC6yk2PEXqCQVbfDMPMk0
        dKlopZ9FjoNWjl05y3SjUB6NOi8/gKxVIt+I2ClRwmQ0/VLcwMzyaSHPv2rxV1anKweQY9m3XIQfH
        y0yxoRrZ6vDAKtSWekqPITGc8ujWG+j7WaH8lml8MMpLWmi+XWu2V2wkHn0Tgc3HRoN10Lm9Fgv3d
        vNI1xB9n5OXOBLQemgtFyEfc6hvievL1Hz38yqP06XO2MnhwiKY8S53WJhHH8qhfEpYj8vfHG5Asb
        //mOpvTg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4YR-0001cp-Fe; Thu, 29 Oct 2020 09:49:11 +0000
Date:   Thu, 29 Oct 2020 09:49:11 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/26] libfrog: list the bigtime feature when reporting
 geometry
Message-ID: <20201029094911.GN2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375537005.881414.6068353624094235785.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375537005.881414.6068353624094235785.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:36:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're reporting on a filesystem's geometry, report if the bigtime
> feature is enabled on this filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
