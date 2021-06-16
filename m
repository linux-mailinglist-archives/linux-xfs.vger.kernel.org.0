Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D249D3A93E6
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Jun 2021 09:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhFPHcA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Jun 2021 03:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhFPHb7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 03:31:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD3AC061574;
        Wed, 16 Jun 2021 00:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4GCV0Tsl9j3lJlXQ4rbWDvezMHLiQ0/tKeLjBqffbk8=; b=Pltu/WkcjlSddkvOsd7WjIjCxM
        Vb7V0LfOrqXe3UjkG9ckVeuuuUX4Sv8zLzALI1MXGKKQT4GX32zfdI91ZMWNgkITz+LBjoX4vmHB9
        SEV1wUbQ9Ma6kIxYrtFifbMFFlF2/c5f4wWGJqvwAEK6msmxwBPR7L0kzdwYqUuJQxabN9Vn8ip2e
        sqEDtV2PxfV5pWcpkGvdzNVStkoBRQRleTjaCboPfYc3BkJAMRBKHcG3WDF+Sl8HcHQeUHPHCHrly
        MWjrWVj9ATvpuiV1rX7wJUTpjxwwC99Thp1AL7Aun9LQX9x3uh/n+a0LwXl9fQW7+rojP3MKE+Lbl
        iHe2dkrA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltPzC-007kVq-Pr; Wed, 16 Jun 2021 07:29:26 +0000
Date:   Wed, 16 Jun 2021 08:29:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Subject: Re: [PATCH 04/13] fstests: add tool migrate group membership data to
 test files
Message-ID: <YMmoTpc7rqRXIHd/@infradead.org>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370436132.3800603.3564234435790687757.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162370436132.3800603.3564234435790687757.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 01:59:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a tool to migrate the mapping of tests <-> groups out of the
> group file and into the individual test file as a _begin_fstest
> call.  In the next patches we'll rewrite all the test files and auto
> generate the group files from the tests.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
