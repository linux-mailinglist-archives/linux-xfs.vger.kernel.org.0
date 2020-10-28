Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6B529D480
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Oct 2020 22:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgJ1Vwa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Oct 2020 17:52:30 -0400
Received: from casper.infradead.org ([90.155.50.34]:44310 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728343AbgJ1Vwa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:52:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7bzRZY7TBHeEQ/2417FS//whgYfR5YmoYwEt/p0xlAw=; b=LgmtcdfyTZTGcMF5sd4j2Wm5lz
        dxDmts7e6Elvzy9RArmr1ZWMlHy6gUXobHdPF02qAukoYkyEO+fM18I0rL+M0D+1N0ONvcDAY8oXt
        My7xsQEFOJ5x2wEswRiIblLZxfRZ6kJZdW+PwWvJDK+P7/PYATnV/FvpQFAPkBth9uSWTcB8uSYcz
        OofghRfjr0p/k30Yc92MydlLVziLu7EY25YYM3JglGnnz0orsAWCihh3w68ha/TAcc5b8Ys1TFvXY
        antHPqRVtkDohL38kfG1tPdnuITdZHymtyMOIp2HAtQ4BNkDRtrioSkiZyNlyoToWvgL2TrnDclEx
        FPC6r/Zw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXg7r-0000sp-P7; Wed, 28 Oct 2020 07:44:07 +0000
Date:   Wed, 28 Oct 2020 07:44:07 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 8/9] check: run tests in a systemd scope for mandatory
 test cleanup
Message-ID: <20201028074407.GH2750@infradead.org>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <160382534122.1202316.7161591166906029132.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382534122.1202316.7161591166906029132.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:02:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If systemd is available, run each test in its own temporary systemd
> scope.  This enables the test harness to forcibly clean up all of the
> test's child processes (if it does not do so itself) so that we can move
> into the post-test unmount and check cleanly.

Can you explain what this mean in more detail?  Most importantly what
problems it fixes.
