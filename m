Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E304A0359
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Jan 2022 23:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343671AbiA1WQW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jan 2022 17:16:22 -0500
Received: from sandeen.net ([63.231.237.45]:42854 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230408AbiA1WQW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jan 2022 17:16:22 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E37E078FD;
        Fri, 28 Jan 2022 16:16:08 -0600 (CST)
Message-ID: <62858eec-5c59-04f9-8c3d-db4f2aec3a0b@sandeen.net>
Date:   Fri, 28 Jan 2022 16:16:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH 34/45] xfs_{copy,db,logprint,repair}: replace
 xfs_sb_version checks with feature flag checks
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263803029.860211.854355789042037468.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <164263803029.860211.854355789042037468.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:20 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Convert the xfs_sb_version_hasfoo() to checks against mp->m_features.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


