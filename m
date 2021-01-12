Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2DF2F36C4
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Jan 2021 18:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404668AbhALRNi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Jan 2021 12:13:38 -0500
Received: from verein.lst.de ([213.95.11.211]:56478 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404475AbhALRNi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jan 2021 12:13:38 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id DBF0367373; Tue, 12 Jan 2021 18:12:55 +0100 (CET)
Date:   Tue, 12 Jan 2021 18:12:55 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: refactor xfs_file_fsync
Message-ID: <20210112171255.GA31287@lst.de>
References: <20210111161544.1414409-1-hch@lst.de> <20210111161544.1414409-2-hch@lst.de> <20210112153347.GB1137163@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112153347.GB1137163@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 12, 2021 at 10:33:47AM -0500, Brian Foster wrote:
> Looks fine, though it might be nice to find some commonality with
> xfs_log_force_inode():

The common logic is called xfs_log_force_lsn :)

The fact that fsync checks and modifies ili_fsync_fields makes it rather
impractival to share more code unfortunately.
