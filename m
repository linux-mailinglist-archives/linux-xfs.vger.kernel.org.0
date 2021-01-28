Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119EB307096
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Jan 2021 09:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhA1IDM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Jan 2021 03:03:12 -0500
Received: from verein.lst.de ([213.95.11.211]:56327 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232218AbhA1IB1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 03:01:27 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id A26EB68AFE; Thu, 28 Jan 2021 09:00:34 +0100 (CET)
Date:   Thu, 28 Jan 2021 09:00:34 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reduce ilock acquisitions in xfs_file_fsync
Message-ID: <20210128080034.GA29023@lst.de>
References: <20210122164643.620257-1-hch@lst.de> <20210122164643.620257-3-hch@lst.de> <20210125131618.GA2047559@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125131618.GA2047559@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 08:16:18AM -0500, Brian Foster wrote:
> > -	error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> > +	/*
> > +	 * Any inode that has dirty modifications in the log is pinned.  The
> > +	 * racy check here for a pinned inode while not catch modifications
> 
> s/while/will/ ?

Yes.  Darrick, can you fix this up when applying the patch, or do you
want me to resend?
