Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FADF33090A
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Mar 2021 08:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhCHH4e (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Mar 2021 02:56:34 -0500
Received: from verein.lst.de ([213.95.11.211]:54516 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229971AbhCHH4I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 02:56:08 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 93C6A68B02; Mon,  8 Mar 2021 08:56:06 +0100 (CET)
Date:   Mon, 8 Mar 2021 08:56:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v2.1 2/4] xfs: avoid buffer deadlocks when walking fs
 inodes
Message-ID: <20210308075606.GD983@lst.de>
References: <161514874040.698643.2749449122589431232.stgit@magnolia> <161514875165.698643.17020544838073213424.stgit@magnolia> <20210307203638.GJ3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307203638.GJ3419940@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
