Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E9A1C9611
	for <lists+linux-xfs@lfdr.de>; Thu,  7 May 2020 18:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgEGQLY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 May 2020 12:11:24 -0400
Received: from verein.lst.de ([213.95.11.211]:47601 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgEGQLV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 May 2020 12:11:21 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0A25968B05; Thu,  7 May 2020 18:11:18 +0200 (CEST)
Date:   Thu, 7 May 2020 18:11:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: libxfs 5.7 resync
Message-ID: <20200507161117.GA718@lst.de>
References: <20200507121851.304002-1-hch@lst.de> <20200507154809.GH6714@magnolia> <20200507155454.GB32006@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507155454.GB32006@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

And FYI, the xfs_check failures also appear with your branch.
