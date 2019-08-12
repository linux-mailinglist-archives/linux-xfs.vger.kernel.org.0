Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2DE8A3A8
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 18:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfHLQq4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 12:46:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44332 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfHLQq4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:46:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGhoTb190814
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:46:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=CFxPKGKvN3W6XU/WmSc0KhMMbhsH/dUwG4GFBNrjBjM=;
 b=GvlXzzprWNlFQ0isVD4yaWChZ7TQQ31t3k2/DP07Aaey86gr1qAQDN4WCJ3Xdw8bY/V3
 ZjgmjmyekXQrPrEuEZSkjVTYIi6+aN0CA+4ea+us27aiv8rgiEqZ1xrz2vu/D3XiBfLr
 8JQarGiSJSqYUp0vchMIUGEpTwaPS0niMnWScTi3k38FEB74a7DwQcC5uDsmtqaV3Pzc
 YqT1xf898iNRbb5QWR8lV1jBZUJmEadOZtIFA7c9ORUyM3HIY6zWHY3Ld/JImnaTwF8a
 42vAc0/heslTH54/eIB5+GRYJA3OWjtCLw9sh0182tiLtK4S6QK28WCI/bJ3+lZ9JRuQ HQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=CFxPKGKvN3W6XU/WmSc0KhMMbhsH/dUwG4GFBNrjBjM=;
 b=rY+rYZZK7DDEHGo8p6Lt0kBirt/8IkvdSsfltSRzUb8ve7MB4AF7MZECp0x7pY7XzZLB
 cENowK392jtHMAdSiX1o7/lMfzw6+9nsZs4xEClSdqJ2ZI5Z7NK+iD5HEgq2FCmOb0r2
 CDx54y+XMr+Svb6Aku5oAsYLr8g9zTGIvOLNky3qw16ZF3IDqxEprAeNyL2AIgmu/eI7
 oYH9lvp6AMTuuH5VlIqBVtWTqWoEmCoWwMV9Yr70Z8vW2p3mWnspoMYfHkfLb1LhipQz
 bidB1zZyLioJHNp5bnvdROdwljL3W8lXmFpbef7cEvDYlcx8zWOt/XFNYSwEXPWL+8OV cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u9nvp0vtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:46:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGcS5V102611
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:46:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u9n9h2vmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:46:52 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CGkqBQ019687
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:46:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 09:46:51 -0700
Date:   Mon, 12 Aug 2019 09:46:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 19/19] xfsprogs: Add log item printing for ATTRI and
 ATTRD
Message-ID: <20190812164651.GF7138@magnolia>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
 <20190809213804.32628-20-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213804.32628-20-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120187
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:38:04PM -0700, Allison Collins wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch implements a new set of log printing functions to
> print the ATTRI and ATTRD items and vectors in the log.  These
> will be used during log dump and log recover operations.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  logprint/log_misc.c      |  31 +++++++-
>  logprint/log_print_all.c |  12 +++
>  logprint/log_redo.c      | 189 +++++++++++++++++++++++++++++++++++++++++++++++
>  logprint/logprint.h      |   7 ++
>  4 files changed, 238 insertions(+), 1 deletion(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index c325f04..7b2055d 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -54,11 +54,29 @@ print_stars(void)
>  	   "***********************************\n");
>  }	/* print_stars */
>  
> +void
> +print_hex_dump(char *ptr, int len) {
> +	int i = 0;
> +
> +	for (i = 0; i < len; i++) {
> +		if (i % 16 == 0)
> +			printf("%08x ", i);
> +
> +		printf("%02x", ptr[i]);
> +
> +		if ((i+1)%16 == 0)
> +			printf("\n");
> +		else if ((i+1)%2 == 0)
> +			printf(" ");
> +	}
> +	printf("\n");
> +}

Maybe it's time to implement xfs_hex_dump?

--D

> +
>  /*
>   * Given a pointer to a data segment, print out the data as if it were
>   * a log operation header.
>   */
> -static void
> +void
>  xlog_print_op_header(xlog_op_header_t	*op_head,
>  		     int		i,
>  		     char		**ptr)
> @@ -949,6 +967,17 @@ xlog_print_record(
>  					be32_to_cpu(op_head->oh_len));
>  			break;
>  		    }
> +		    case XFS_LI_ATTRI: {
> +                        skip = xlog_print_trans_attri(&ptr,
> +                                        be32_to_cpu(op_head->oh_len),
> +                                        &i);
> +                        break;
> +                    }
> +                    case XFS_LI_ATTRD: {
> +                        skip = xlog_print_trans_attrd(&ptr,
> +                                        be32_to_cpu(op_head->oh_len));
> +                        break;
> +                    }
>  		    case XFS_LI_RUI: {
>  			skip = xlog_print_trans_rui(&ptr,
>  					be32_to_cpu(op_head->oh_len),
> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index eafffe2..f794a68 100644
> --- a/logprint/log_print_all.c
> +++ b/logprint/log_print_all.c
> @@ -400,6 +400,12 @@ xlog_recover_print_logitem(
>  	case XFS_LI_EFI:
>  		xlog_recover_print_efi(item);
>  		break;
> +	case XFS_LI_ATTRD:
> +		xlog_recover_print_attrd(item);
> +		break;
> +	case XFS_LI_ATTRI:
> +		xlog_recover_print_attri(item);
> +		break;
>  	case XFS_LI_RUD:
>  		xlog_recover_print_rud(item);
>  		break;
> @@ -452,6 +458,12 @@ xlog_recover_print_item(
>  	case XFS_LI_EFI:
>  		printf("EFI");
>  		break;
> +	case XFS_LI_ATTRD:
> +		printf("ATTRD");
> +		break;
> +	case XFS_LI_ATTRI:
> +		printf("ATTRI");
> +		break;
>  	case XFS_LI_RUD:
>  		printf("RUD");
>  		break;
> diff --git a/logprint/log_redo.c b/logprint/log_redo.c
> index f1f690e..005fd84 100644
> --- a/logprint/log_redo.c
> +++ b/logprint/log_redo.c
> @@ -8,6 +8,7 @@
>  #include "libxlog.h"
>  
>  #include "logprint.h"
> +#include "xfs_attr_item.h"
>  
>  /* Extent Free Items */
>  
> @@ -653,3 +654,191 @@ xlog_recover_print_bud(
>  	f = item->ri_buf[0].i_addr;
>  	xlog_print_trans_bud(&f, sizeof(struct xfs_bud_log_format));
>  }
> +
> +/* Attr Items */
> +
> +static int
> +xfs_attri_copy_log_format(
> +	char				*buf,
> +	uint				len,
> +	struct xfs_attri_log_format	*dst_attri_fmt)
> +{
> +	uint dst_len = sizeof(struct xfs_attri_log_format);
> +
> +	if (len == dst_len) {
> +		memcpy((char *)dst_attri_fmt, buf, len);
> +		return 0;
> +	}
> +
> +	fprintf(stderr, _("%s: bad size of attri format: %u; expected %u\n"),
> +		progname, len, dst_len);
> +	return 1;
> +}
> +
> +int
> +xlog_print_trans_attri(
> +	char				**ptr,
> +	uint				src_len,
> +	int				*i)
> +{
> +	struct xfs_attri_log_format	*src_f = NULL;
> +	xlog_op_header_t		*head = NULL;
> +	uint				dst_len;
> +	int				error = 0;
> +
> +	dst_len = sizeof(struct xfs_attri_log_format);
> +	if (src_len != dst_len) {
> +		fprintf(stderr, _("%s: bad size of attri format: %u; expected %u\n"),
> +				progname, src_len, dst_len);
> +		return 1;
> +	}
> +
> +	/*
> +	 * memmove to ensure 8-byte alignment for the long longs in
> +	 * xfs_attri_log_format_t structure
> +	 */
> +	if ((src_f = (struct xfs_attri_log_format *)malloc(src_len)) == NULL) {
> +		fprintf(stderr, _("%s: xlog_print_trans_attri: malloc failed\n"),
> +				progname);
> +		exit(1);
> +	}
> +	memmove((char*)src_f, *ptr, src_len);
> +	*ptr += src_len;
> +
> +	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
> +		src_f->alfi_size, src_f->alfi_name_len, src_f->alfi_value_len,
> +				(unsigned long long)src_f->alfi_id);
> +
> +	if (src_f->alfi_name_len > 0) {
> +		printf(_("\n"));
> +		(*i)++;
> +		head = (xlog_op_header_t *)*ptr;
> +		xlog_print_op_header(head, *i, ptr);
> +		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
> +		if (error)
> +			goto error;
> +	}
> +
> +	if (src_f->alfi_value_len > 0) {
> +		printf(_("\n"));
> +		(*i)++;
> +		head = (xlog_op_header_t *)*ptr;
> +		xlog_print_op_header(head, *i, ptr);
> +		error = xlog_print_trans_attri_value(ptr, be32_to_cpu(head->oh_len),
> +				src_f->alfi_value_len);
> +	}
> +error:
> +	free(src_f);
> +
> +	return error;
> +}	/* xlog_print_trans_attri */
> +
> +int
> +xlog_print_trans_attri_name(
> +	char				**ptr,
> +	uint				src_len)
> +{
> +
> +	printf(_("ATTRI:  name len:%u\n"), src_len);
> +	print_hex_dump(*ptr, src_len);
> +
> +	*ptr += src_len;
> +
> +	return 0;
> +}	/* xlog_print_trans_attri */
> +
> +int
> +xlog_print_trans_attri_value(
> +	char				**ptr,
> +	uint				src_len,
> +	int				value_len)
> +{
> +	printf(_("ATTRI:  value len:%u\n"), value_len);
> +	print_hex_dump(*ptr, value_len);
> +
> +	*ptr += src_len;
> +
> +	return 0;
> +}	/* xlog_print_trans_attri_value */
> +
> +void
> +xlog_recover_print_attri(
> +	xlog_recover_item_t	*item)
> +{
> +	struct xfs_attri_log_format	*f, *src_f = NULL;
> +	uint				src_len, dst_len;
> +
> +	int				region = 0;
> +
> +	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].i_addr;
> +	src_len = item->ri_buf[region].i_len;
> +
> +	/*
> +	 * An xfs_attri_log_format structure contains a attribute name and
> +	 * variable length value  as the last field.
> +	 */
> +	dst_len = sizeof(struct xfs_attri_log_format);
> +
> +	if ((f = ((struct xfs_attri_log_format *)malloc(dst_len))) == NULL) {
> +		fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
> +			progname);
> +		exit(1);
> +	}
> +	if (xfs_attri_copy_log_format((char*)src_f, src_len, f))
> +		goto out;
> +
> +	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
> +		f->alfi_size, f->alfi_name_len, f->alfi_value_len, (unsigned long long)f->alfi_id);
> +
> +	if (f->alfi_name_len > 0) {
> +		region++;
> +		printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
> +		print_hex_dump((char *)item->ri_buf[region].i_addr,
> +			       f->alfi_name_len);
> +	}
> +
> +	if (f->alfi_value_len > 0) {
> +		region++;
> +		printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
> +		print_hex_dump((char *)item->ri_buf[region].i_addr,
> +			       f->alfi_value_len);
> +	}
> +
> +out:
> +	free(f);
> +
> +}
> +
> +int
> +xlog_print_trans_attrd(char **ptr, uint len)
> +{
> +	struct xfs_attrd_log_format *f;
> +	struct xfs_attrd_log_format lbuf;
> +	uint core_size = sizeof(struct xfs_attrd_log_format);
> +
> +	memcpy(&lbuf, *ptr, MIN(core_size, len));
> +	f = &lbuf;
> +	*ptr += len;
> +	if (len >= core_size) {
> +		printf(_("ATTRD:  #regs: %d	id: 0x%llx\n"),
> +			f->alfd_size,
> +			(unsigned long long)f->alfd_alf_id);
> +		return 0;
> +	} else {
> +		printf(_("ATTRD: Not enough data to decode further\n"));
> +		return 1;
> +	}
> +}	/* xlog_print_trans_attrd */
> +
> +void
> +xlog_recover_print_attrd(
> +	xlog_recover_item_t		*item)
> +{
> +	struct xfs_attrd_log_format	*f;
> +
> +	f = (struct xfs_attrd_log_format *)item->ri_buf[0].i_addr;
> +
> +	printf(_("	ATTRD:  #regs: %d	id: 0x%llx\n"),
> +		f->alfd_size,
> +		(unsigned long long)f->alfd_alf_id);
> +}
> diff --git a/logprint/logprint.h b/logprint/logprint.h
> index 98ac0d4..b76c590 100644
> --- a/logprint/logprint.h
> +++ b/logprint/logprint.h
> @@ -28,6 +28,7 @@ extern void xfs_log_print_trans(struct xlog *, int);
>  extern void print_xlog_record_line(void);
>  extern void print_xlog_op_line(void);
>  extern void print_stars(void);
> +extern void print_hex_dump(char* ptr, int len);
>  
>  extern struct xfs_inode_log_format *
>  	xfs_inode_item_format_convert(char *, uint, struct xfs_inode_log_format *);
> @@ -52,4 +53,10 @@ extern void xlog_recover_print_bui(struct xlog_recover_item *item);
>  extern int xlog_print_trans_bud(char **ptr, uint len);
>  extern void xlog_recover_print_bud(struct xlog_recover_item *item);
>  
> +extern int xlog_print_trans_attri(char **ptr, uint src_len, int *i);
> +extern int xlog_print_trans_attri_name(char **ptr, uint src_len);
> +extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len);
> +extern void xlog_recover_print_attri(xlog_recover_item_t *item);
> +extern int xlog_print_trans_attrd(char **ptr, uint len);
> +extern void xlog_recover_print_attrd(xlog_recover_item_t *item);
>  #endif	/* LOGPRINT_H */
> -- 
> 2.7.4
> 
