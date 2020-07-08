Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03755217FC8
	for <lists+linux-xfs@lfdr.de>; Wed,  8 Jul 2020 08:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbgGHGq4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 Jul 2020 02:46:56 -0400
Received: from casper.infradead.org ([90.155.50.34]:55940 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgGHGqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 02:46:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CZOkXyyY4dgTf+kqhDB3CzWaT/nYODB1edBU1B7TMHo=; b=Vfj7EemWn0U7Dyc0oY5B906K8S
        9ugYUiV/I6FJet6p3M/VQZNm5IK2/eSgrUp/yQf03dVOma3gP1oP3OnIAmsuH6GPX8RHhv8ME7ivo
        SQ8F7y76xBBWRVK8tT+GpMly9fDrmVC0Mtnh8R18lieKPZZ1ItR1+QVrxPX/jkwkUFbkgHqlgviS6
        Pcb48VNK/4CyIyvR9foBO8UAN38gX7+SusbdxgYHr8d1mlQIBx9wfm02FUiOrFn1Xvj99dQPMWAlV
        J5oBi41NEX1EgV8YVc7EoM49Xw105fojdyqsze5CuWSTCfwjVIG5sPcf6x3aviaZUiy+Y1niULCbc
        1WZCuwZg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jt3gv-0002Xg-Bh; Wed, 08 Jul 2020 06:36:56 +0000
Date:   Wed, 8 Jul 2020 07:36:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_repair: complain about ag header crc errors
Message-ID: <20200708063623.GA9080@infradead.org>
References: <159370361029.3579756.1711322369086095823.stgit@magnolia>
 <159370361687.3579756.17807287829667417464.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159370361687.3579756.17807287829667417464.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 02, 2020 at 08:26:56AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Repair doesn't complain about crc errors in the AG headers, and it
> should.  Otherwise, this gives the admin the wrong impression about the
> state of the filesystem after a nomodify check.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
