Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AB626D5D7
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 10:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgIQIKR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 04:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIQIKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:10:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2701C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 01:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=o627oDqg44aIKHlKRiF8jM2KbXapiGHw/RbMf87BIQ0=; b=I3wbzOhzwoXGZC6p6faeTfWwuY
        m3ex8DGqJaZfVlATii4oi72hOga9EYioX4eF0ETDs9fNTcE7VYHWjBPBV5jwbdsO2WpOzlMX3V0mN
        bJzL/c0u6Cmf0W4GGpEC36vBA0bwtBNSyVJIA0hFgqxT9IzsqRjrwpnxPmBnJUdmik2HviCUC6wKn
        /k8vJk4ctG2swMTlmUvw9PgwMDeV3w59tGbvwGih41SiX8hVi5Pt/N94pkLhOznBw6KuGWUi0nldG
        OlmLhFYuVeXiTd5SenOxyXJd5ULNdjcBWwSaPCskfr4/HEz71jBoQ92QftgiEZhfaq1p4dYKtNeM7
        g473stpg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIozV-0008Qi-BU; Thu, 17 Sep 2020 08:10:05 +0000
Date:   Thu, 17 Sep 2020 09:10:05 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] mkfs.xfs: fix ASSERT on too-small device with stripe
 geometry
Message-ID: <20200917081005.GC26262@infradead.org>
References: <20200916204056.29247-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916204056.29247-1-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 10:40:56PM +0200, Pavel Reichl wrote:
> When a too-small device is created with stripe geometry, we hit an
> assert in align_ag_geometry():
> 
> mkfs.xfs: xfs_mkfs.c:2834: align_ag_geometry: Assertion `cfg->agcount != 0' failed.
> 
> This is because align_ag_geometry() finds that the size of the last
> (only) AG is too small, and attempts to trim it off.  Obviously 0
> AGs is invalid, and we hit the ASSERT.
> 
> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
